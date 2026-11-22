function id = validateId(value)
    if ~isnumeric(value) || ~isscalar(value) || ~isreal(value) || ...
            ~isfinite(value) || value < 1 || value > flintmax || ...
            value ~= fix(value)
        error('arka:validation:InvalidId', 'An ID must be a positive, finite integer not exceeding flintmax.');
    end

    id = double(value);
end