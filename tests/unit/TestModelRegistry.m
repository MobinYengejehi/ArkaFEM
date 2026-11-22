classdef TestModelRegistry < matlab.unittest.TestCase
    methods(Test)
        function emptyModelAndDimensions(testCase)
            m = arka.Model("2D", "Truss");
            testCase.verifyEqual(m.Space, "2D");
            testCase.verifyEqual(m.Family, "Truss");
            testCase.verifyEqual(m.Revision, 0);
            testCase.verifyEmpty(m.listNodes());
            testCase.verifyEmpty(m.listMaterials());
            testCase.verifyEmpty(m.listSections());
            result = m.validate();
            testCase.verifyTrue(result.IsValid);
            testCase.verifyEmpty(result.Issues);
        end

        function twoDimensionalNodeOrdering(testCase)
            m = arka.Model("2D", "Truss");
            m.addNode(10, [3; 4]);
            m.addNode(2, [0, 0]);

            nodes = m.listNodes();
            testCase.verifyEqual([nodes.Id], [2 10]);

            node = m.getNode(10);
            testCase.verifyEqual(node.Coordinates, [3 4]);
            testCase.verifyEqual(m.Revision, 2);

            info = m.summary();
            testCase.verifyEqual(info.NodeCount, 2);
        end

        function threeDimensionalCoordinates(testCase)
            m = arka.Model("3D", "Truss");
            n = m.addNode(1, [1 2 3]);

            testCase.verifyEqual(n.Coordinates, [1 2 3]);
            testCase.verifyEqual(m.Space, "3D");
            testCase.verifyEqual(m.Revision, 1);
        end

        function materialValuesAndModules(testCase)
            m = arka.Model("2D", "Truss");
            s = m.addMaterial("Steel", 'Id', 5, 'kind', "steel", ...
                'E', 210e9, 'nu', 0.3, 'rho', 7850, ...
                'alpha', 12e-6);

            testCase.verifyEqual(s.Id, 5);
            testCase.verifyEqual(s.G, 210e9 / 2.6, 'RelTol', 1e-14);
            testCase.verifyEqual(m.getMaterial(5), m.getMaterial("Steel"));
            
            m.addMaterial("Concrete", 'E', 30e9, 'nu', 0.2, 'rho', 2400);
            
            materials = m.listMaterials();
            
            testCase.verifyEqual([materials.Id], [5 6]);

            concrete = m.getMaterial("Concrete");
            testCase.verifyEqual(concrete.Alpha, 0);
        end

        function sectionReferencesAndRevisions(testCase)
            m = arka.Model("2D", "Truss");
            m.addMaterial("Steel", 'E', 200e9, 'nu', 0.3, 'rho', 7850);
            s = m.addSection("Bar", "Steel", 'Id', 12, 'A', 0.002);
            
            testCase.verifyEqual(s.MaterialName, "Steel");
            testCase.verifyEqual(s.MaterialId, 1);
            testCase.verifyEqual(s.Shape, "General");
            testCase.verifyEmpty(s.J);
            testCase.verifyEqual(s.A, 0.002);
            testCase.verifyEqual(m.getSection(12), m.getSection("Bar"));
            testCase.verifyEqual(m.Revision, 2);
            
            summary = m.summary();
            testCase.verifyEqual([summary.NodeCount summary.MaterialCount ...
                summary.SectionCount], [0 1 1]);
            
            validation = m.validate();
            testCase.verifyTrue(validation.IsValid);
        end

        function sectionMomentOptional(testCase)
            m = arka.Model("3D", "Frame");
            steel = m.addMaterial("Steel", 'E', 200e9, ...
                'nu', 0.3, 'rho', 7850, 'G', 200e9/2.6);
            s = m.addSection("General", steel.Id, 'A', 0.01, ...
                'Iy', 1e-5, 'Iz', 2e-5, 'J', 3e-6);
            
            testCase.verifyEqual([s.Iy s.Iz s.J], [1e-5 2e-5 3e-6]);
            testCase.verifyEqual(s.Modifiers.J, 1);
        end

        function snapshotDetachedFromHandle(testCase)
            m = arka.Model("2D", "Truss");
            m.addNode(1, [0 0]);
            m.addMaterial("Steel", 'E', 200e9, 'nu', 0.3, 'rho', 7800);
            m.addSection("Bar", "Steel", 'A', 0.001);

            previous = m.snapshot();
            previous.Nodes(1).Coordinates(1) = 987;
            previous.Materials(1).E = -1;
            previous.Sections(1).Modifiers.A = -1;
            
            node = m.getNode(1);
            testCase.verifyEqual(node.Coordinates, [0 0]);
            
            material = m.getMaterial("Steel");
            testCase.verifyEqual(material.E, 200e9);
            
            section = m.getSection("Bar");
            testCase.verifyEqual(section.Modifiers.A, 1);
            testCase.verifyEqual(m.Revision, 3);
            
            m.addNode(2, [3 0]);
            testCase.verifyEqual(previous.Revision, 3);
            testCase.verifyEqual(numel(previous.Nodes), 1);
            
            latest = m.snapshot();
            testCase.verifyEqual(numel(latest.Nodes), 2);
        end

        function directResultMutationDoesNotAffectModel(testCase)
            m = arka.Model("2D", "Truss");
            node = m.addNode(8, [2 3]);
            node.Id = 999;

            nodes = m.listNodes();
            nodes(1).Coordinates = [9 9];
            
            original = m.getNode(8);
            testCase.verifyEqual(original.Coordinates, [2 3]);
            testCase.verifyEqual(m.Revision, 1);
        end
    end
end