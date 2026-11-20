classdef TestBootstrap < matlab.unittest.TestCase
    %TESTBOOTSTRAP First executable MATLAB tests for Stage 01A.
    methods (Test)
        function packageVersionMetadata(testCase)
            info = arka.version();
            testCase.verifyEqual(info.Name, "ArkaFEM");
            testCase.verifyEqual(info.Version, "0.0.1-dev");
            testCase.verifyEqual(info.MATLABTarget, "R2024b+");
            testCase.verifyFalse(info.MATLABVerified);
            testCase.verifyEqual(info.AvailableAPI, "arka.version");
        end

        function packageParentIsUsable(testCase)
            location = which('arka.version');
            testCase.verifyNotEmpty(location);
            testCase.verifyTrue(endsWith(string(location), ...
                fullfile('+arka', 'version.m')));
        end
    end
end
