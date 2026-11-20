%RUN_ALL_TESTS Run actual MATLAB unit tests; fail if there are no tests.
arkaTestRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(arkaTestRoot, 'scripts', 'setupArkaFEM.m'));
arkaTestResults = runtests(fullfile(arkaTestRoot, 'tests'), ...
    'IncludeSubfolders', true);
disp(arkaTestResults);
if isempty(arkaTestResults) || ~all([arkaTestResults.Passed])
    error('arka:qa:TestsFailed', ...
        'MATLAB tests had failures/incomplete results or no tests were found.');
end
fprintf('ArkaFEM MATLAB unit tests PASS: %d tests.\n', ...
    numel(arkaTestResults));
clear arkaTestRoot arkaTestResults
