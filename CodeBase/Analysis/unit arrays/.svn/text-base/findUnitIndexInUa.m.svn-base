function k = findUnitIndexInUa(ua,expt_name,unit_tag)
% function k = findUnitIndexInUa(ua,expt_name,unit_tag)
%
%
%
%

% Created: SRO - 5/27/11

k = [];
numFound = 0;
for m = 1:length(expt_name)
    temp_tags = unit_tag{m};
    search_name = expt_name{m};
    for n = 1:length(temp_tags)   
        unitFound = 0;
        search_tag = temp_tags{n};
        for u = 1:length(ua)
            test_name = ua(u).expt_name;
            test_tag = ua(u).unit_tag;
            if strcmp(test_name,search_name) && strcmp(test_tag,search_tag)
               unitFound = 1;
                numFound = numFound+1;
                k(end+1) = u;
                break
            end
        end
        if ~unitFound
            disp('missing unit:')
            disp([search_name ' ' search_tag])
        end
    end
end

