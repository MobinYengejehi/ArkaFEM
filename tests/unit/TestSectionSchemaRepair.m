classdef TestSectionSchemaRepair < matlab.unittest.TestCase
    %TESTSECTIONSCHEMAREPAIR Guard first and subsequent General sections.
    methods (Test)
        function firstSectionUsesValidatedSchema(testCase)
            m = arka.Model("2D", "Truss");
            initial = m.snapshot();
            testCase.verifyEmpty(initial.Sections);
            m.addMaterial("Steel", 'E', 210e9, 'nu', 0.3, 'rho', 7850);
            section = m.addSection("BarA", "Steel", 'A', 0.002);
            testCase.verifyEqual(section.Name, "BarA");
            testCase.verifyEqual(section.A, 0.002);
            testCase.verifyEqual(section.ReferenceSource, "userInput");
            testCase.verifyEqual(section.Modifiers.A, 1);
            testCase.verifyEqual(m.getSection("BarA"), section);
            testCase.verifyEqual(fieldnames(m.listSections()), ...
                fieldnames(section));
            testCase.verifyEqual(m.Revision, 2);
        end

        function repeatedSectionsUseSameFieldSet(testCase)
            m = arka.Model("3D", "Frame");
            m.addMaterial("Steel", 'E', 200e9, 'nu', 0.3, 'rho', 7850);
            first = m.addSection("BarA", "Steel", 'Id', 9, ...
                'A', 0.002, 'Iy', 2e-6, 'Iz', 3e-6, 'J', 4e-6);
            second = m.addSection("BarB", "Steel", 'Id', 3, ...
                'A', 0.004);
            sections = m.listSections();
            testCase.verifyEqual([sections.Id], [3 9]);
            testCase.verifyEqual(fieldnames(first), fieldnames(second));
            testCase.verifyEmpty(second.Iy);
            testCase.verifyEqual(sections(2).J, 4e-6);
            testCase.verifyEqual(numel(sections), 2);
            testCase.verifyEqual(m.Revision, 3);
        end

        function failedSectionDoesNotMutateRegistry(testCase)
            m = arka.Model("2D", "Truss");
            m.addMaterial("Steel", 'E', 200e9, 'nu', 0.3, 'rho', 7850);
            m.addSection("BarA", "Steel", 'A', 0.002);
            previous = m.snapshot();
            testCase.verifyError(@() m.addSection("Bad", "Steel", ...
                'A', -1), 'arka:validation:InvalidProperty');
            current = m.snapshot();
            testCase.verifyEqual(current.Revision, previous.Revision);
            testCase.verifyEqual(current.Sections, previous.Sections);
        end
    end
end
