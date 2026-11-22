function record = validateMaterial(id, name, options, revision)
%VALIDATEMATERIAL Validate data-only linear-isotropic material properties.
    E = arka.internal.core.validateScalar(options.E, 'E [Pa]', 'positive');
    nu = arka.internal.core.validateScalar(options.nu, 'nu [-]', 'poisson');
    rho = arka.internal.core.validateScalar(options.rho, 'rho [kg/m^3]', 'nonnegative');
    alpha = arka.internal.core.validateScalar(options.alpha, 'alpha [1/K]', 'finite');
    G = E / (2 * (1 + nu));
    if ~isfinite(G) || G <= 0
        error('arka:validation:InvalidProperty', ...
            'E and nu produce a non-finite shear modulus G.');
    end
    if ~isempty(options.G)
        requestedG = arka.internal.core.validateScalar(options.G, 'G [Pa]', 'positive');
        if abs(requestedG - G) > 1e-9 * max([G, requestedG])
            error('arka:validation:InvalidProperty', ...
                'Provided G is inconsistent with E/(2*(1+nu)).');
        end
    end
    kind = lower(arka.internal.core.validateName(options.Kind));
    if ~any(strcmp(kind, ["steel", "concrete", "aluminum", "rebar", "generic"]))
        error('arka:validation:InvalidProperty', ...
            'Kind must be steel, concrete, aluminum, rebar or generic.');
    end
    record = struct('Id', id, 'Name', name, 'Kind', kind, ...
        'ConstitutiveModel', "linearIsotropic", 'E', E, 'Nu', nu, ...
        'Rho', rho, 'Alpha', alpha, 'G', G, 'Revision', revision);
end
