function info = version()
%VERSION Return release and compatibility metadata for ArkaFEM.
%   INFO = arka.version() returns metadata only; it does not solve FEM models.
%   R2024b+ is a compatibility target, not an executed compatibility claim.
%
%   No additional toolboxes are required for this function.

    info = struct();
    info.Name = "ArkaFEM";
    info.Version = "0.0.1-dev";
    info.Stage = "01A";
    info.MATLABTarget = "R2024b+";
    info.MATLABVerified = false;
    info.Units = "SI";
    info.AvailableAPI = "arka.version";
end
