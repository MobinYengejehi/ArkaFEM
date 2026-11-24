function mapping = buildDofMap(nodeIds, family, revision)
    if nargin ~= 3
        error('arka:validation:InvalidArgument', 'buildDofMap needs node IDs, family and revision.');
    end

    if ~(isstring(family) && isscalar(family)) && ...
            ~(ischar(family) && isrow(family))
        error('arka:validation:InvalidFamily', 'Family must be a character vector or string scalar.');
    end

    family = string(family);
    if ismissing(family) || strlength(family) == 0
        error('arka:validation:InvalidFamily', 'Family must be nonempty.');
    end

    switch family
        case "1D"
            labels = "UX";
            space = "1D";
        case "2DTruss"
            labels = ["UX", "UY"];
            space = "2D";
        case "2DFrame"
            labels = ["UX", "UY", "RZ"];
            space = "2D";
        case "3DTruss"
            labels = ["UX", "UY", "UZ"];
            space = "3D";
        case "3DFrame"
            labels = ["UX", "UY", "UZ", "RX", "RY", "RZ"];
            space = "3D";
        otherwise
            error('arka:validation:InvalidFamily', 'Unsupported kinematic family: %s.', char(family));
    end

    if ~isa(nodeIds, 'double') || ~isreal(nodeIds) || ...
            issparse(nodeIds) || ~isvector(nodeIds) || isempty(nodeIds) || ...
            any(~isfinite(nodeIds(:))) || any(nodeIds(:) < 1) || ...
            any(nodeIds(:) ~= fix(nodeIds(:))) || ...
            any(nodeIds(:) > flintmax)
        error('arka:validation:InvalidId', 'Node IDs must be nonempty, positive, unique, exact double integers.');
    end

    nodeIds = sort(reshape(nodeIds, 1, []));
    if any(diff(nodeIds) == 0)
        error('arka:validation:DuplicateId', 'Duplicate node IDs are not allowed in the DOF map.');
    end

    nNodes = numel(nodeIds);
    nPerNode = numel(labels);
    if nNodes > floor(flintmax / nPerNode)
        error('arka:validation:InvalidId', 'DOF index exceeds exact double integer range.');
    end

    indices = reshape(1:(nNodes * nPerNode), nPerNode, nNodes).';
    mapping = struct('Space', space, 'Family', family, ...
        'NodeIds', nodeIds, 'Labels', labels, ...
        'Indices', indices, 'DofsPerNode', nPerNode, ...
        'TotalDofs', nNodes * nPerNode, ...
        'ModelRevision', revision, 'Units', "SI");
end