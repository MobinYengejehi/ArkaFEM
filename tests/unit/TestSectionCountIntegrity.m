classdef TestSectionCountIntegrity < matlab.unittest.TestCase
    %TESTSECTIONCOUNTINTEGRITY Regression for phantom empty sections.
    methods (Test)
        function oneSectionMeansExactlyOneRecord(testCase)
            m = arka.Model("2D", "Truss");
            initial = m.summary();
            testCase.verifyEqual(initial.SectionCount, 0);
            testCase.verifyEmpty(m.listSections());

            m.addMaterial("Steel", 'E', 200e9, 'nu', 0.3, 'rho', 7850);
            one = m.addSection("BarA", "Steel", 'A', 0.002);
            afterOne = m.summary();
            testCase.verifyEqual(afterOne.SectionCount, 1);
            testCase.verifyEqual(m.Revision, 2);
            testCase.verifyEqual(one.Revision, 2);
            sections = m.listSections();
            testCase.verifyEqual(numel(sections), 1);
            testCase.verifyEqual(sections(1).Name, "BarA");
            testCase.verifyEqual([sections.Id], 1);
            testCase.verifyEqual(fieldnames(sections), fieldnames(one));
        end

        function twoSectionsHaveNoExtraPlaceholder(testCase)
            m = arka.Model("2D", "Truss");
            m.addMaterial("Steel", 'E', 200e9, 'nu', 0.3, 'rho', 7850);
            m.addSection("BarB", "Steel", 'Id', 5, 'A', 0.001);
            m.addSection("BarA", "Steel", 'Id', 2, 'A', 0.002);
            afterTwo = m.summary();
            testCase.verifyEqual(afterTwo.SectionCount, 2);
            testCase.verifyEqual(m.Revision, 3);
            sections = m.listSections();
            testCase.verifyEqual(numel(sections), 2);
            testCase.verifyEqual([sections.Id], [2 5]);
            testCase.verifyEqual([sections.A], [0.002 0.001]);
            testCase.verifyTrue(all([sections.Id] > 0));
        end

        function rejectedSectionDoesNotChangeCount(testCase)
            m = arka.Model("2D", "Truss");
            m.addMaterial("Steel", 'E', 200e9, 'nu', 0.3, 'rho', 7850);
            m.addSection("BarA", "Steel", 'A', 0.002);
            before = m.summary();
            testCase.verifyError(@() m.addSection("Invalid", "Steel", ...
                'A', -1), 'arka:validation:InvalidProperty');
            after = m.summary();
            testCase.verifyEqual(after.SectionCount, before.SectionCount);
            testCase.verifyEqual(after.Revision, before.Revision);
        end
    end
end
