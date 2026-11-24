classdef TestDofMapping < matlab.unittest.TestCase
    methods (Test)
        function oneDUnsortedIds(testCase)
            map = arka.dofMap([33 1 9], "1D");
            testCase.verifyEqual(map.NodeIds, [1 9 33]);
            testCase.verifyEqual(map.Indices, [1; 2; 3]);
            testCase.verifyEqual(map.Labels, "UX");
            testCase.verifyEqual(arka.dofIndex(map, 33, "UX"), 3);
            testCase.verifyEmpty(map.ModelRevision);
        end

        function twoDTrussAndFrame(testCase)
            m = arka.Model("2D", "Truss");
            m.addNode(50, [5 0]);
            m.addNode(2, [0 0]);
            rev = m.Revision;
            t = arka.dofMap(m);
            testCase.verifyEqual(t.Family, "2DTruss");
            testCase.verifyEqual(t.NodeIds, [2 50]);
            testCase.verifyEqual(t.Labels, ["UX" "UY"]);
            testCase.verifyEqual(t.Indices, [1 2; 3 4]);
            testCase.verifyEqual(t.ModelRevision, rev);
            testCase.verifyEqual(m.Revision, rev); % pure, no cache mutation
            f = arka.dofMap([50 2], "2DFrame");
            testCase.verifyEqual(f.Indices, [1 2 3; 4 5 6]);
            testCase.verifyEqual(f.Labels, ["UX" "UY" "RZ"]);
            testCase.verifyEqual(arka.dofIndex(f, 50, "RZ"), 6);
        end

        function threeDFamilies(testCase)
            t = arka.dofMap([3 1], "3DTruss");
            testCase.verifyEqual(t.Indices, [1 2 3; 4 5 6]);
            testCase.verifyEqual(t.Labels, ["UX" "UY" "UZ"]);
            m = arka.Model("3D", "Frame");
            m.addNode(17, [1 2 3]);
            m.addNode(4, [0 0 0]);
            f = arka.dofMap(m);
            testCase.verifyEqual(f.Indices, [1:6; 7:12]);
            testCase.verifyEqual(f.NodeIds, [4 17]);
            testCase.verifyEqual(f.Labels, ...
                ["UX" "UY" "UZ" "RX" "RY" "RZ"]);
            testCase.verifyEqual(arka.dofIndex(f, 17, "RY"), 11);
        end

        function deterministicUnderInsertionOrder(testCase)
            one = arka.dofMap([6 2 18 4], "2DTruss");
            two = arka.dofMap([18 4 6 2], "2DTruss");
            testCase.verifyEqual(one, two);
        end
    end
end
