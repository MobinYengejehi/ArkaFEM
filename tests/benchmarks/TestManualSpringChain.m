classdef TestManualSpringChain < matlab.unittest.TestCase
    methods (Test)
        function nc11KnownDisplacementReaction(testCase)
            K = sparse([1e6 -1e6 0; -1e6 3e6 -2e6; 0 -2e6 2e6]);
            F = [0; 0; 3000];
            r = arka.solveDirichlet(K, F, 1, 0);
            testCase.verifyEqual(r.Displacements, [0; .003; .0045], ...
                'AbsTol', 1e-12);
            testCase.verifyEqual(r.Reactions, [-3000; 0; 0], ...
                'AbsTol', 1e-7);
            testCase.verifyLessThan(r.NormalizedFreeResidual, 1e-12);
            testCase.verifyEqual(r.ConstrainedDofs, 1);
            testCase.verifyEqual(r.FreeDofs, [2; 3]);
            testCase.verifyEqual(r.NNZ, nnz(K));
        end

        function nonzeroPrescribedSettlement(testCase)
            % Fix left node at +1 mm. The free displacements translate +1 mm.
            K = sparse([1e6 -1e6 0; -1e6 3e6 -2e6; 0 -2e6 2e6]);
            F = [0; 0; 3000];
            r = arka.solveDirichlet(K, F, 1, .001);
            testCase.verifyEqual(r.Displacements, [.001; .004; .0055], ...
                'AbsTol', 1e-12);
            testCase.verifyEqual(r.SupportReactions, -3000, 'AbsTol', 1e-7);
            testCase.verifyLessThan(r.NormalizedFreeResidual, 1e-12);
        end

        function sortedConstraintsAndNonzeroLoadsAtSupports(testCase)
            K = sparse([10 -10 0; -10 20 -10; 0 -10 10]);
            F = [2; 0; 3];
            % End DOFs known: U3=.2, U1=0 -> U2=0.1
            r = arka.solveDirichlet(K, F, [3 1], [.2 0]);
            testCase.verifyEqual(r.ConstrainedDofs, [1;3]);
            testCase.verifyEqual(r.PrescribedValues, [0; .2]);
            testCase.verifyEqual(r.Displacements, [0; .1; .2], 'AbsTol', 1e-12);
            testCase.verifyEqual(r.Reactions, [-3; 0; -2], 'AbsTol', 1e-12);
        end

        function unconstrainedNonsingularSystem(testCase)
            r = arka.solveDirichlet(sparse(diag([2 4])), [6; 8], [], []);
            testCase.verifyEqual(r.Displacements, [3; 2], 'AbsTol', 1e-12);
            testCase.verifyEqual(r.Reactions, [0; 0], 'AbsTol', 1e-12);
            testCase.verifyEmpty(r.ConstrainedDofs);
        end

        function sparseConditionEstimateBranch(testCase)
            n = 129;
            K = 2 * speye(n);
            F = ones(n, 1);
            r = arka.solveDirichlet(K, F, [], []);
            testCase.verifyEqual(r.Displacements, 0.5 * F, 'AbsTol', 1e-12);
            testCase.verifyLessThan(r.NormalizedFreeResidual, 1e-12);
        end

        function allKnownDofs(testCase)
            r = arka.solveDirichlet(sparse([2 -1; -1 2]), ...
                [1; 2], [2 1], [0.25 0]);
            testCase.verifyEqual(r.Displacements, [0; 0.25]);
            testCase.verifyEqual(r.Reactions, [-1.25; -1.5]);
            testCase.verifyEmpty(r.FreeDofs);
            testCase.verifyEqual(r.NormalizedFreeResidual, 0);
        end
    end
end
