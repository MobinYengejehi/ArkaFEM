%DOFMAP Deterministic, family-specific node to global DOF mapping.
%   MAP = arka.dofMap(MODEL) uses a 2D/3D arka.Model's node IDs and
%   kinematic family, without modifying its Revision.
%   MAP = arka.dofMap(NODEIDS, FAMILY) additionally permits the 1D
%   prototype. FAMILY is one of "1D", "2DTruss", "2DFrame",
%   "3DTruss", "3DFrame". Mixed-family active unions are not supported.
%   Output indices are MATLAB 1-based and sorted by ascending node ID.
function mapping = dofMap(source, family)
    if nargin == 1 && isa(source, 'arka.Model')
        model = source;
        nodes = model.listNodes();
        ids = [nodes.Id];
        family = model.Space + model.Family;
        revision = model.Revision;
    elseif nargin == 2 && ~isa(source, 'arka.Model')
        ids = source;
        revision = [];
    else
        error('arka:validation:InvalidArgument', 'Use dofMap(model) or dofMap(nodeIds, family).');
    end
    
    mapping = arka.internal.core.buildDofMap(ids, family, revision);
end