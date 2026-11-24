classdef TestDofSolverValidation < matlab.unittest.TestCase
    methods (Test)
        function duplicateAndInvalidNodes(testCase)
            testCase.verifyError(@() arka.dofMap([2 2], "1D"), ...
                'arka:validation:DuplicateId');
            testCase.verifyError(@() arka.dofMap([3 NaN], "2DFrame"), ...
                'arka:validation:InvalidId');
            testCase.verifyError(@() arka.dofMap([], "1D"), ...
                'arka:validation:InvalidId');
            testCase.verifyError(@() arka.dofMap([1 2], "Mixed"), ...
                'arka:validation:InvalidFamily');
            testCase.verifyError(@() arka.dofMap([1 2]), ...
                'arka:validation:InvalidArgument');
        end

        function malformedDofLabelsAndFamily(testCase)
            mapping = arka.dofMap([1 3], "2DTruss");
            testCase.verifyError(@() arka.dofIndex(mapping, 1, ""), ...
                'arka:validation:InvalidDof');
            testCase.verifyError(@() arka.dofIndex(mapping, 1, "RZ"), ...
                'arka:validation:InvalidDof');
            testCase.verifyError(@() arka.dofMap(1, ""), ...
                'arka:validation:InvalidFamily');
        end

        function unknownAndInactiveDof(testCase)
            map = arka.dofMap([2 7], "2DTruss");
            testCase.verifyError(@() arka.dofIndex(map, 8, "UY"), ...
                'arka:validation:UnknownRecord');
            testCase.verifyError(@() arka.dofIndex(map, 7, "RZ"), ...
                'arka:validation:InvalidDof');
        end

        function malformedKAndF(testCase)
            testCase.verifyError(@() arka.solveDirichlet(eye(2,3), [0; 0], 1, 0), ...
                'arka:solver:InvalidMatrix');
            testCase.verifyError(@() arka.solveDirichlet(eye(2), [1 2], 1, 0), ...
                'arka:solver:InvalidVector');
            testCase.verifyError(@() arka.solveDirichlet(eye(2), 1, 1, 0), ...
                'arka:solver:InvalidVector');
            testCase.verifyError(@() arka.solveDirichlet(eye(2), [1; 1], [0 1], [0 0]), ...
                'arka:solver:InvalidConstraint');
        end

        function nonfiniteKAndInputs(testCase)
            K = sparse([1 Inf; 1 2]);
            testCase.verifyError(@() arka.solveDirichlet(K, [1; 1], 1, 0), ...
                'arka:solver:NonFiniteData');
            testCase.verifyError(@() arka.solveDirichlet(eye(2), [1; NaN], 1, 0), ...
                'arka:solver:NonFiniteData');
            testCase.verifyError(@() arka.solveDirichlet(eye(2), [1; 1], 1, Inf), ...
                'arka:solver:NonFiniteData');
            testCase.verifyError(@() arka.solveDirichlet(eye(2), [1; 1], NaN, 0), ...
                'arka:solver:NonFiniteData');
        end

        function contradictoryAndRepeatedRestraints(testCase)
            testCase.verifyError(@() arka.solveDirichlet(eye(2), [0; 0], ...
                [1 1], [0 .001]), 'arka:solver:ConflictingConstraint');
            testCase.verifyError(@() arka.solveDirichlet(eye(2), [0; 0], ...
                [1 1], [0 0]), 'arka:solver:DuplicateConstraint');
        end

        function singularFreeBlock(testCase)
            K = sparse([1 -1 0; -1 1 0; 0 0 0]);
            testCase.verifyError(@() arka.solveDirichlet(K, [0; 0; 0], 1, 0), ...
                'arka:solver:SingularSystem');
            testCase.verifyError(@() arka.solveDirichlet(sparse([1 -1; -1 1]), ...
                [0; 1], [], []), 'arka:solver:SingularSystem');
        end

        function missingSolverArguments(testCase)
            testCase.verifyError(@() arka.solveDirichlet(eye(2), [0; 0], 1), ...
                'arka:validation:InvalidArgument');
        end

        function malformedMapStruct(testCase)
            mapping = arka.dofMap([1 2], "2DTruss");
            missing = rmfield(mapping, 'Family');
            testCase.verifyError(@() arka.dofIndex(missing, 1, "UX"), ...
                'arka:validation:InvalidArgument');
            malformed = mapping;
            malformed.Indices = 1;
            testCase.verifyError(@() arka.dofIndex(malformed, 1, "UX"), ...
                'arka:validation:InvalidArgument');
            malformed = mapping;
            malformed.Indices(1, 1) = 100;
            testCase.verifyError(@() arka.dofIndex(malformed, 1, "UX"), ...
                'arka:validation:InvalidArgument');
        end

        function reducedRhsOverflow(testCase)
            K = [1 -realmax; -realmax 1];
            testCase.verifyError(@() arka.solveDirichlet(K, [0; 0], 1, 2), ...
                'arka:solver:NonFiniteData');
        end

        function illConditionedFreeBlock(testCase)
            K = sparse(diag([1 1e-13]));
            testCase.verifyError(@() arka.solveDirichlet(K, [1; 1], [], []), ...
                'arka:solver:IllConditionedSystem');
        end
    end
end
