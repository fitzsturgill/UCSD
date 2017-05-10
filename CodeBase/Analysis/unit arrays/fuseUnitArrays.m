function ua = fuseUnitArrays(uaCellArray)
% function ua = fuseUnitArrays(uaCellArray)
%
% INPUT
%   uaCellArray: Cell array of unit arrays to be fused to together
%
%

% Created: SRO - 6/6/11


all_fields = {};
all_classes = '';
for i = 1:length(uaCellArray)
    tempFields = fieldnames(uaCellArray{i});
    tempUa = uaCellArray{i};
    % Generate list of all fields across all arrays
    for m = 1:length(tempFields)
        if ~any(strcmp(tempFields{m},all_fields));
            all_fields{end+1} = tempFields{m};
            all_classes{end+1} = class(tempUa(1).(tempFields{m}));
        end
    end
end

unitInd = 1;
for i = 1:length(uaCellArray)
    for u = 1:length(uaCellArray{i})
        tempUa = uaCellArray{i};
        for m = 1:length(all_fields)
            if isfield(tempUa,all_fields{m})
                ua(unitInd).(all_fields{m}) = tempUa(u).(all_fields{m});
            else
                switch all_classes{m}
                    case 'single'
                        ua(u).(all_fields{m}) = [];
                    case 'double'
                        ua(u).(all_fields{m}) = [];
                    case 'struct'
                        ua(u).(all_fields{m}) = struct;
                    case 'char'
                        ua(u).(all_fields{m}) = '';
                    case 'cell'
                        ua(u).(all_fields{m}) = cell(0);
                end
                ua(u).(all_fields{m}) = [];
            end
        end
        unitInd = unitInd + 1;
    end
end








