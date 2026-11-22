function record = validateSection(id, name, material, options, revision)
    shape = arka.internal.core.validateName(options.Shape);
    if shape ~= "General"
        error('arka:validation:InvalidProperty', 'Stage 01B supports only the data-only General section shape.');
    end

    A = arka.internal.core.validateScalar(options.A, 'A [m^2]', 'positive');
    optional = { 'Iy', 'Iz', 'J', 'Asy', 'Asz' };
    values = cell(size(optional));

    for i = 1:numel(optional)
        field = optional{i};
        if isempty(options.(field))
            values{i} = [];
        else
            values{i} = arka.internal.core.validateScalar(options.(field), field, 'positive');
        end
    end

    record = struct('Id', id, 'Name', name, ...
        'MaterialId', material.Id, 'MaterialName', material.Name, ...
        'Shape', shape, 'A', A, ...
        'Iy', values{1}, 'Iz', values{2}, 'J', values{3}, ...
        'Asy', values{4}, 'Asz', values{5}, ...
        'CalculationMethod', "userSupplied", ...
        'ReferenceSource', "userInput", ...
        'Modifiers', struct('A', 1, 'Iy', 1, 'Iz', 1, 'J', 1, 'Asy', 1, 'Asz', 1), ...
        'Revision', revision);
end