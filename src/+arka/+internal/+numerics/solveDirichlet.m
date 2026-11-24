%SOLVEDIRICHLET Pure numerical partitioned linear static solve.
%   R = arka.internal.numerics.solveDirichlet(K,F,C,UC)
%   K is a manually supplied finite real NxN double stiffness matrix;
%   F is Nx1 finite real double; C is a vector of constrained 1-based
%   DOF indices; UC prescribes their displacements (including nonzero).
%   No elements, loads or stiffness matrices are assembled here.
%   Reactions use R = K*U-F; free entries are equilibrium residuals.
function result = solveDirichlet(K, F, constrainedDofs, values)
    if nargin ~= 4
        error('arka:validation:InvalidArgument', 'Expected K, F, constrained DOFs and prescribed values.');
    end

    if ~isa(K, 'double') || ~isreal(K) || ~ismatrix(K) || ...
            isempty(K) || size(K, 1) ~= size(K, 2)
        error('arka:solver:InvalidMatrix', 'K must be a nonempty, real square double matrix.');
    end

    n = size(K, 1);
    if ~isa(F, 'double') || ~isreal(F) || ...
            ~isequal(size(F), [n, 1]) || issparse(F)
        error('arka:solver:InvalidVector', 'F must be a real full Nx1 double vector.');
    end

    if any(~isfinite(nonzeros(K))) || any(~isfinite(F))
        error('arka:solver:NonFiniteData', 'K and F must contain only finite values.');
    end

    if ~isa(constrainedDofs, 'double') || ~isreal(constrainedDofs) || ...
            issparse(constrainedDofs) || ...
            (~isempty(constrainedDofs) && ~isvector(constrainedDofs)) || ...
            ~isa(values, 'double') || ~isreal(values) || ...
            issparse(values) || ...
            (~isempty(values) && ~isvector(values)) || ...
            numel(constrainedDofs) ~= numel(values)
        error('arka:solver:InvalidConstraint', 'Constraint indices and prescribed values must be double vectors of equal length.');
    end

    c = constrainedDofs(:);
    uc = values(:);
    if any(~isfinite(c)) || any(~isfinite(uc))
        error('arka:solver:NonFiniteData', 'Constraint DOFs and values must be finite.');
    end

    if any(c < 1) || any(c > n) || any(c ~= fix(c))
        error('arka:solver:InvalidConstraint', 'Constrained DOF indices must be integers in [1, N].');
    end

    [c, order] = sort(c);
    uc = uc(order);
    duplicated = find(diff(c) == 0);
    if ~isempty(duplicated)
        if any(uc(duplicated) ~= uc(duplicated + 1))
            error('arka:solver:ConflictingConstraint', 'The same DOF was prescribed contradictory values.');
        end
        error('arka:solver:DuplicateConstraint', 'Repeated constraint DOF; provide each constrained DOF once.');
    end

    K = sparse(K);
    f = setdiff((1:n).', c, 'stable');
    U = zeros(n, 1);
    U(c) = uc;

    conditionEstimate = NaN;
    normResidual = 0;

    if ~isempty(f)
        Kff = K(f, f);
        rhs = F(f) - K(f, c) * uc;
        if any(~isfinite(rhs))
            error('arka:solver:NonFiniteData', 'The reduced right-hand side overflowed.');
        end

        if nnz(Kff) == 0
            error('arka:solver:SingularSystem', 'Free stiffness block is zero: unrestrained mechanism.');
        end

        if numel(f) <= 128
            reciprocalCondition = rcond(full(Kff));
            if ~isfinite(reciprocalCondition) || reciprocalCondition == 0
                error('arka:solver:SingularSystem', 'The free stiffness block Kff is singular.');
            end

            conditionEstimate = 1 / reciprocalCondition;
        else
            try
                conditionEstimate = condest(Kff);
            catch cause
                error('arka:solver:ConditionEstimateFailed', 'Cannot estimate conditioning of Kff: %s', cause.message);
            end

            if isinf(conditionEstimate)
                error('arka:solver:SingularSystem', 'The free stiffness block Kff is singular.');
            end
            if isnan(conditionEstimate) || conditionEstimate < 1
                error('arka:solver:ConditionEstimateFailed', 'Invalid condition estimate for Kff.');
            end
        end

        if conditionEstimate >= 1e12
            error('arka:solver:IllConditionedSystem', 'Kff condition estimate >= 1e12; reject unstable solve.');
        end

        uf = Kff \ rhs;
        if any(~isfinite(uf)) || ~isreal(uf)
            error('arka:solver:NonFiniteSolution', 'Solver produced nonfinite or nonreal displacements.');
        end

        U(f) = uf;
        residual = Kff * uf - rhs;
        denominator = max(norm(Kff, 1) * norm(uf, 1) + norm(rhs, 1), eps);

        if ~isfinite(denominator) || any(~isfinite(residual))
            error('arka:solver:NonFiniteSolution', 'Equilibrium residual or its normalization overflowed.');
        end

        normResidual = norm(residual, 1) / denominator;
        if ~isfinite(normResidual) || normResidual > 1e-8
            error('arka:solver:ResidualTooLarge', 'Reduced equilibrium residual exceeds 1e-8 normalized tolerance.');
        end
    end

    reactions = K * U - F;
    if any(~isfinite(reactions))
        error('arka:solver:NonFiniteSolution', 'Recovered reactions contain nonfinite values.');
    end

    result = struct('Displacements', U, 'Reactions', reactions, ...
        'FreeDofs', f, 'ConstrainedDofs', c, ...
        'PrescribedValues', uc, 'FreeResidual', reactions(f), ...
        'SupportReactions', reactions(c), ...
        'NormalizedFreeResidual', normResidual, ...
        'ConditionEstimate', conditionEstimate, ...
        'TotalDofs', n, 'FreeDofCount', numel(f), ...
        'NNZ', nnz(K), 'Solver', "sparse backslash", 'Units', "SI");
end