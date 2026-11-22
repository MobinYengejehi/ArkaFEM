function result = validateScalar(value, fieldName, criterion)
    if ~isnumeric(value) || ~isscalar(value) || ~isreal(value) || ...
            ~isfinite(value) || issparse(value)
        error('arka:validation:InvalidProperty', '%s must be a finite, real numeric scaler.', fieldName);
    end

    result = double(value);

    switch criterion
        case 'positive'
            valid = result > 0;
        case 'nonnegative'
            valid = result >= 0;
        case 'poisson'
            valid = result > -1 && result < 0.5;
        case 'finite'
            valid = true;
        otherwise
            error('arka:validation:InvalidArgument', 'Unknown validation criterion: %s.', criterion);
    end

    if ~valid
        error('arka:validation:InvalidProperty', '%s fails the %s numerical constraint.', fieldName, criterion);
    end
end