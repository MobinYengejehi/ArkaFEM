classdef Model < handle
    %MODEL Validated, revisioned, data-only model facade (Stage 01B).
    %   M = arka.Model("2D","Truss") or arka.Model("3D","Frame")
    %   stores nodes, linear-isotropic materials and manually supplied
    %   General sections. No element assembly or analysis is available.
    %
    %   Only <repository>/src must be added to the MATLAB path.
    %   Registries are private and all query/snapshot outputs are value
    %   structs, not handles to internal mutable state.
    
    properties (SetAccess = private)
        Space
        Family
        Revision = 0
    end
    properties (Access = private)
        Nodes = struct('Id', {}, 'Coordinates', {}, 'Revision', {})
        Materials = struct('Id', {}, 'Name', {}, 'Kind', {}, ...
            'ConstitutiveModel', {}, 'E', {}, 'Nu', {}, 'Rho', {}, ...
            'Alpha', {}, 'G', {}, 'Revision', {})
        Sections = struct('Id', {}, 'Name', {}, 'MaterialId', {}, ...
            'MaterialName', {}, 'Shape', {}, 'A', {}, 'Iy', {}, ...
            'Iz', {}, 'J', {}, 'Asy', {}, 'Asz', {}, ...
            'CalculationMethod', {}, 'ReferenceSource', {}, ...
            'Modifiers', {}, 'Revision', {})
    end
    methods
        function obj = Model(space, family)
            if nargin ~= 2
                error('arka:validation:InvalidArgument', ...
                    'Construct a model with (space, family).');
            end
            space = arka.internal.core.validateName(space);
            family = arka.internal.core.validateName(family);
            if ~any(strcmpi(space, ["2D", "3D"]))
                error('arka:validation:InvalidDimension', ...
                    'Space must be "2D" or "3D".');
            end
            if ~any(strcmpi(family, ["Truss", "Frame"]))
                error('arka:validation:InvalidFamily', ...
                    'Family must be "Truss" or "Frame".');
            end
            obj.Space = upper(space);
            if strcmpi(family, "Truss")
                obj.Family = "Truss";
            else
                obj.Family = "Frame";
            end
            % A registry must start with zero records, not a placeholder
            % struct whose fields are empty. Preserve its field schema.
            obj.Sections = obj.Sections([]);
        end

        function record = addNode(obj, id, coordinates)
            %ADDNODE Add a uniquely numbered 2D/3D node, coordinates in m.
            if nargin ~= 3
                error('arka:validation:InvalidArgument', ...
                    'addNode requires ID and coordinates.');
            end
            id = arka.internal.core.validateId(id);
            dimension = 2;
            if obj.Space == "3D"
                dimension = 3;
            end
            coordinates = arka.internal.core.validateNode(coordinates, dimension);
            if any([obj.Nodes.Id] == id)
                error('arka:validation:DuplicateId', ...
                    'Node ID %g already exists.', id);
            end
            record = struct('Id', id, 'Coordinates', coordinates, ...
                'Revision', obj.Revision + 1);
            obj.Nodes(end+1) = record;
            obj.Revision = obj.Revision + 1;
        end

        function record = addMaterial(obj, name, varargin)
            %ADDMATERIAL Register isotropic elastic material (SI units).
            %   m.addMaterial("Steel", 'E', 200e9, 'nu', 0.3, 'rho', 7850)
            %   Optional: Id, Kind, Alpha, G (G must be consistent).
            if nargin < 2
                error('arka:validation:InvalidArgument', ...
                    'addMaterial requires a material name.');
            end
            name = arka.internal.core.validateName(name);
            defaults = struct('Id', [], 'Kind', "generic", ...
                'E', [], 'nu', [], 'rho', [], 'alpha', 0, 'G', []);
            options = arka.internal.core.parseOptions(defaults, varargin{:});
            if ~isempty(obj.Materials) && ...
                    any(strcmp([obj.Materials.Name], name))
                error('arka:validation:DuplicateName', ...
                    'Material name "%s" already exists.', char(name));
            end
            id = obj.nextId(obj.Materials, options.Id);
            record = arka.internal.core.validateMaterial( ...
                id, name, options, obj.Revision + 1);
            obj.Materials(end+1) = record;
            obj.Revision = obj.Revision + 1;
        end

        function record = addSection(obj, name, materialRef, varargin)
            %ADDSECTION Register data-only General section with material.
            %   m.addSection("A1", "Steel", 'A', 0.01)
            %   Optional: Id, Shape="General", Iy, Iz, J, Asy, Asz.
            if nargin < 3
                error('arka:validation:InvalidArgument', ...
                    'addSection requires a name and material reference.');
            end
            name = arka.internal.core.validateName(name);
            defaults = struct('Id', [], 'Shape', "General", ...
                'A', [], 'Iy', [], 'Iz', [], 'J', [], ...
                'Asy', [], 'Asz', []);
            options = arka.internal.core.parseOptions(defaults, varargin{:});
            if ~isempty(obj.Sections) && ...
                    any(strcmp([obj.Sections.Name], name))
                error('arka:validation:DuplicateName', ...
                    'Section name "%s" already exists.', char(name));
            end
            material = obj.lookup(obj.Materials, materialRef, 'Material');
            id = obj.nextId(obj.Sections, options.Id);
            record = arka.internal.core.validateSection( ...
                id, name, material, options, obj.Revision + 1);
            if isempty(obj.Sections) || ...
                    (isscalar(obj.Sections) && isempty(obj.Sections(1).Id))
                % Replace an obsolete one-record empty template. It is not
                % a registered section and must not inflate SectionCount.
                obj.Sections = record;
            else
                % MATLAB requires matching struct fields on indexed assignment.
                % Check the schema, then normalize field ordering.
                if ~isequal(sort(fieldnames(obj.Sections)), ...
                        sort(fieldnames(record)))
                    error('arka:internal:SectionSchemaMismatch', ...
                        'Section validator output is inconsistent with the registry.');
                end
                obj.Sections(end + 1) = orderfields(record, obj.Sections);
            end
            obj.Revision = obj.Revision + 1;
        end

        function record = getNode(obj, id)
            id = arka.internal.core.validateId(id);
            index = find([obj.Nodes.Id] == id, 1);
            if isempty(index)
                error('arka:validation:UnknownRecord', ...
                    'Node ID %g does not exist.', id);
            end
            record = obj.Nodes(index);
        end

        function records = listNodes(obj)
            records = obj.sortedRecords(obj.Nodes);
        end

        function record = getMaterial(obj, ref)
            record = obj.lookup(obj.Materials, ref, 'Material');
        end

        function records = listMaterials(obj)
            records = obj.sortedRecords(obj.Materials);
        end

        function record = getSection(obj, ref)
            record = obj.lookup(obj.Sections, ref, 'Section');
        end

        function records = listSections(obj)
            records = obj.sortedRecords(obj.Sections);
        end

        function result = summary(obj)
            result = struct('Space', obj.Space, 'Family', obj.Family, ...
                'Revision', obj.Revision, 'Units', "SI", ...
                'NodeCount', numel(obj.Nodes), ...
                'MaterialCount', numel(obj.Materials), ...
                'SectionCount', numel(obj.Sections));
        end

        function result = snapshot(obj)
            %SNAPSHOT Obtain an independent value struct of registry state.
            result = struct('SchemaVersion', 1, 'Space', obj.Space, ...
                'Family', obj.Family, 'Revision', obj.Revision, ...
                'Units', "SI", 'Nodes', obj.listNodes(), ...
                'Materials', obj.listMaterials(), ...
                'Sections', obj.listSections());
        end

        function result = validate(obj)
            %VALIDATE Return model-data integrity diagnostics (no solve).
            % Preallocate the upper bound to avoid growing the issues array.
            issues = strings(numel(obj.Sections), 1);
            issueCount = 0;
            materialIds = [obj.Materials.Id];
            for i = 1:numel(obj.Sections)
                if ~any(materialIds == obj.Sections(i).MaterialId)
                    issueCount = issueCount + 1;
                    issues(issueCount) = ...
                        "Missing material reference in section " + obj.Sections(i).Name;
                end
            end
            issues = issues(1:issueCount);
            result = struct('IsValid', isempty(issues), ...
                'Issues', issues, 'Revision', obj.Revision, ...
                'Summary', obj.summary());
        end
    end
    methods (Access = private)
        function id = nextId(~, records, requested)
            if isempty(requested)
                if isempty(records)
                    id = 1;
                else
                    id = max([records.Id]) + 1;
                end
                if id > flintmax
                    error('arka:validation:InvalidId', ...
                        'Automatic IDs exhausted the exactly representable range.');
                end
            else
                id = arka.internal.core.validateId(requested);
            end
            if any([records.Id] == id)
                error('arka:validation:DuplicateId', ...
                    'Registry ID %g already exists.', id);
            end
        end

        function record = lookup(~, records, ref, registryName)
            if isnumeric(ref)
                id = arka.internal.core.validateId(ref);
                index = find([records.Id] == id, 1);
            else
                name = arka.internal.core.validateName(ref);
                if isempty(records)
                    index = [];
                else
                    index = find(strcmp([records.Name], name), 1);
                end
            end
            if isempty(index)
                error('arka:validation:MissingReference', ...
                    '%s reference was not found in this model.', registryName);
            end
            record = records(index);
        end

        function records = sortedRecords(~, records)
            if ~isempty(records)
                [~, order] = sort([records.Id]);
                records = records(order);
            end
        end
    end
end
