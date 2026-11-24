%SOLVEDIRICHLET Solve a supplied stiffness system via Dirichlet elimination.
%   OUT = arka.solveDirichlet(K,F,CONSTRAINED,VALUES) uses the internal
%   numerical kernel. The matrix K is supplied manually in Stage 01C;
%   this public convenience function does NOT assemble FEM elements.
function result = solveDirichlet(K, F, constrainedDofs, values)
    if nargin ~= 4
        error('arka:validation:InvalidArgument', 'Expected K, F, constrained DOFs and prescribed values.');
    end

    result = arka.internal.numerics.solveDirichlet(K, F, constrainedDofs, values);
end