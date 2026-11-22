exampleRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(exampleRoot, 'scripts', 'setupArkaFEM.m'));

m = arka.Model("2D", "Truss");
m.addNode(2, [3, 0]);
m.addNode(1, [0, 0]);

m.addMaterial("Steel", 'E', 210e9, 'nu', 0.3, 'rho', 7850, ...
    'Kind', "steel", 'alpha', 12e-6);

m.addSection("BarA", "Steel", 'A', 0.002);

disp(m.summary());
disp(m.listNodes());
disp(m.getMaterial("Steel"));
disp(m.getSection("BarA"));

modelDiagnostics = m.validate();
assert(modelDiagnostics.IsValid, 'Model registry is invalid.');

clear exampleRoot
