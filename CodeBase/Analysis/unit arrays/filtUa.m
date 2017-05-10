function ua = filtUa(ua,filtArray)
% function ua = filtUa(ua,filtArray)
%
% INPUT
%   ua: Unit array
%   filtArray: Cell array of property/value pairs to filter on 
%

% Created: SRO - 6/7/11


k = zeros(length(ua),length(filtArray));
for i = 1:length(filtArray)
    
    for u = 1:length(ua)
        % s is struct with values for test
        fld = filtArray{i}{1};
        val = getVal(ua(u),fld);
        testVal = filtArray{i}{2};
        
        if strcmp(fld,'depth')
            k(u,i) = compareDepth(val,testVal);
        else
            
        k(u,i) = compareVal(val,testVal,fld);
        
        end
        
    end
    
end

k = all(k,2);

ua = ua(k);


function s = getVal(ua,str)
k = findstr(str,'.');
k(end+1) = length(str)+1;
startInd = 1;
tmpS = ua;
% Loop through struct
for i = 1:length(k)
    thisFld = str(startInd:k(i)-1);
    tmpS = tmpS.(thisFld);
    startInd = k(i)+1;
end
s = tmpS;

function k = compareVal(val,testVal,fld)

% Determine variable type
varType = class(testVal);

switch varType
    
    case {'single','double'}
        for i = 1:length(testVal)
            tmp(i) = compareDouble(val(i),testVal(i));
        end
        k = all(tmp);
    case 'char'
        k = strcmp(val,testVal);
        
    case 'logical'
        
end

        
function k = compareDepth(val,depth)

if length(depth) == 1
    depth = [depth-1 depth+1];
end


if val >= depth(1) && val <= depth(2)
    k = 1;
else
    k = 0;
end


