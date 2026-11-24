%EXAMPLE_02_SPRING_SYSTEM Independently supplied spring chain K and F.
%   Source of the system and analytical values: NC-11; no auto-assembly.

arkaExampleRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(arkaExampleRoot, 'scripts', 'setupArkaFEM.m'));

nodes = [20 1 10];
map = arka.dofMap(nodes, "1D");
assert(isequal(map.NodeIds, [1 10 20]));
assert(arka.dofIndex(map, 20, "UX") == 3);

k1 = 1.0e6; % N/m
k2 = 2.0e6; % N/m

K = sparse([k1 -k1 0; -k1 k1+k2 -k2; 0 -k2 k2]);
F = [0; 0; 3000]; % N

out = arka.solveDirichlet(K, F, 1, 0);
expectedU = [0; 0.003; 0.0045]; % m
expectedR = [-3000; 0; 0]; % N

assert(max(abs(out.Displacements - expectedU)) < 1e-12);
assert(max(abs(out.Reactions - expectedR)) < 1e-7);
assert(out.NormalizedFreeResidual < 1e-12);

fprintf('ArkaFEM manual spring-chain proof (01C):\n');

fprintf('U [m] = [%g, %g, %g]\n', out.Displacements);
fprintf('R [N] = [%g, %g, %g]\n', out.Reactions);
fprintf('normalized free residual (1-norm) = %.3g\n', out.NormalizedFreeResidual);

clear arkaExampleRoot nodes map k1 k2 K F out expectedU expectedR
