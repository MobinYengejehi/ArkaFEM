%SETUPARKAFEM Add only the public package parent directory to MATLAB path.
% Usage from the repository root:
%   run(fullfile(pwd, 'scripts', 'setupArkaFEM.m'))
% It is safe to execute repeatedly during a MATLAB session.

arkaSetupScriptsDirectory = fileparts(mfilename('fullpath'));
arkaSetupRootDirectory = fileparts(arkaSetupScriptsDirectory);
arkaSetupSrcDirectory = fullfile(arkaSetupRootDirectory, 'src');
assert(isfolder(fullfile(arkaSetupSrcDirectory, '+arka')), ...
    'arka:setup:MissingSource', 'ArkaFEM src/+arka is missing.');
arkaSetupEntries = strsplit(path, pathsep);
if ~any(strcmp(arkaSetupEntries, arkaSetupSrcDirectory))
    addpath(arkaSetupSrcDirectory, '-begin');
end
clear arkaSetupScriptsDirectory arkaSetupRootDirectory ...
    arkaSetupSrcDirectory arkaSetupEntries
