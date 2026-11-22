function name = validateName(value)
%VALIDATENAME Normalize a nonempty record name while preserving case.
    if ~(isstring(value) && isscalar(value)) && ...
            ~(ischar(value) && (isrow(value) || isempty(value)))
        error('arka:validation:InvalidName', ...
            'Record names must be nonempty character vectors or string scalars.');
    end
    name = strtrim(string(value));
    if ismissing(name) || strlength(name) == 0 || ...
            any(double(char(name)) < 32 | double(char(name)) == 127)
        error('arka:validation:InvalidName', ...
            'Record names must not be empty, missing or contain control characters.');
    end
end
