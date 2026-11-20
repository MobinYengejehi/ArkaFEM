%RUN_LINT MATLAB Code Analyzer; separate from Python static audit.
arkaLintRoot = fileparts(fileparts(mfilename('fullpath')));
arkaLintFiles = [ ...
    dir(fullfile(arkaLintRoot, 'src', '**', '*.m')); ...
    dir(fullfile(arkaLintRoot, 'scripts', '*.m')); ...
    dir(fullfile(arkaLintRoot, 'examples', '*.m')); ...
    dir(fullfile(arkaLintRoot, 'tests', '**', '*.m'))];
if isempty(arkaLintFiles)
    error('arka:qa:LintMissingFiles', 'No MATLAB files were found.');
end
arkaLintIssues = 0;
for arkaLintIndex = 1:numel(arkaLintFiles)
    arkaLintPath = fullfile(arkaLintFiles(arkaLintIndex).folder, ...
        arkaLintFiles(arkaLintIndex).name);
    arkaLintMessages = checkcode(arkaLintPath, '-id');
    if ~isempty(arkaLintMessages)
        fprintf(2, 'MATLAB Code Analyzer: %s\n', arkaLintPath);
        disp(arkaLintMessages);
        arkaLintIssues = arkaLintIssues + numel(arkaLintMessages);
    end
end
if arkaLintIssues > 0
    error('arka:qa:LintFailed', '%d Code Analyzer diagnostics.', arkaLintIssues);
end
fprintf('ArkaFEM MATLAB Code Analyzer PASS: %d files.\n', ...
    numel(arkaLintFiles));
clear arkaLintRoot arkaLintFiles arkaLintIssues arkaLintIndex ...
    arkaLintPath arkaLintMessages
