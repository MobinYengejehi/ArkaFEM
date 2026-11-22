function coords = validateNode(value, dimension)
    if ~isnumeric(value) || ~isvector(value) || ~isreal(value) || ...
            issparse(value) || numel(value) ~= dimension || ...
            ~all(isfinite(value(:)))
        error('arka:validation:InvalidCoordinates', 'Coordinates must be a finite real numeric vector of length %d.', dimension);
    end

    coords = reshape(double(value), 1, []);
    if ~all(isfinite(coords))
        error('arka:validation:InvalidCoordinates', 'Coordinates cannot be represented as finite doubles.');
    end
end