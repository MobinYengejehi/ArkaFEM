%DOFINDEX Query an index from an arka.dofMap result (MATLAB 1-based).
%   IX = arka.dofIndex(MAP, 7, "UY") fails for absent node/DOF.
function index = dofIndex(mapping, nodeId, label)
    if nargin ~= 3 || ~isstruct(mapping) || ~isscalar(mapping) || ...
            ~all(isfield(mapping, {'NodeIds', 'Labels', 'Indices', 'Family'}))
        error('arka:validation:InvalidArgument', 'Pass a dofMap struct, node ID and DOF label.');
    end

    if ~isa(mapping.NodeIds, 'double') || ~isreal(mapping.NodeIds) || ...
            ~isrow(mapping.NodeIds) || isempty(mapping.NodeIds) || ...
            ~isstring(mapping.Labels) || ~isrow(mapping.Labels) || ...
            isempty(mapping.Labels) || any(ismissing(mapping.Labels)) || ...
            ~isstring(mapping.Family) || ~isscalar(mapping.Family) || ...
            ismissing(mapping.Family) || ...
            ~isa(mapping.Indices, 'double') || ~isreal(mapping.Indices) || ...
            ~isequal(size(mapping.Indices), [numel(mapping.NodeIds), numel(mapping.Labels)])
        error('arka:validation:InvalidArgument', 'Invalid DOF map field types or dimensions.');
    end

    nodeId = arka.internal.core.validateId(nodeId);
    if ~(isstring(label) && isscalar(label) && ~ismissing(label)) && ...
            ~(ischar(label) && isrow(label) && ~isempty(label))
        error('arka:validation:InvalidDof', 'DOF label must be a nonempty string scalar or character vector.');
    end

    label = string(label);
    if ismissing(label) || strlength(label) == 0
        error('arka:validation:InvalidDof', 'DOF label must be nonempty.');
    end

    row = find(mapping.NodeIds == nodeId, 1);
    col = find(mapping.Labels == label, 1);
    if isempty(row)
        error('arka:validation:UnknownRecord', 'Node %g is absent from the DOF mapping.', nodeId);
    end
    if isempty(col)
        error('arka:validation:InvalidDof', 'DOF %s is not active in family %s.', char(label), char(mapping.Family));
    end

    index = mapping.Indices(row, col);
    expected = (row - 1) * numel(mapping.Labels) + col;
    if index ~= expected
        error('arka:validation:InvalidArgument', 'DOF map index is inconsitent with canonical ordering.');
    end
end
