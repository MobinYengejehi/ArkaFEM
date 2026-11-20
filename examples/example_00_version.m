%EXAMPLE_00_VERSION Stage 01A: supported minimal MATLAB use.
run(fullfile(fileparts(mfilename('fullpath')), '..', 'scripts', ...
    'setupArkaFEM.m'));
info = arka.version();
disp(info);
% No Model, element, stiffness assembly, or solver API exists at Stage 01A.
