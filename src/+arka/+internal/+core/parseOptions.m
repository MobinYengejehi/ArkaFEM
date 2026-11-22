function options = parseOptions(defaults, varargin)
%PARSEOPTIONS Strict name/value parsing (unknown/duplicate keys fail).
    if mod(numel(varargin), 2) ~= 0
        error('arka:validation:InvalidArgument', ...
            'Optional arguments must be name/value pairs.');
    end
    options = defaults;
    known = fieldnames(defaults);
    used = false(numel(known), 1);
    for i = 1:2:numel(varargin)
        key = varargin{i};
        if ~((isstring(key) && isscalar(key) && ~ismissing(key)) || ...
                (ischar(key) && isrow(key)))
            error('arka:validation:InvalidArgument', ...
                'Option names must be text scalars.');
        end
        index = find(strcmpi(char(key), known), 1);
        if isempty(index)
            error('arka:validation:InvalidProperty', ...
                'Unsupported option: %s.', char(key));
        end
        if used(index)
            error('arka:validation:InvalidArgument', ...
                'Duplicate option: %s.', known{index});
        end
        used(index) = true;
        options.(known{index}) = varargin{i+1};
    end
end
