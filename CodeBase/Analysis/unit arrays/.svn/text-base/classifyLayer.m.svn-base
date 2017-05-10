function ua = classifyLayer(ua)
%
%
%

% Created: SRO - 4/26/11



for i = 1:length(ua)
    d = ua(i).depth;
    
    if ~isnan(d)
        
        if d < 300
            ua(i).layer = 'L2/3';
            
        elseif d < 450
            ua(i).layer = 'L4';
            
        elseif d < 650 
            ua(i).layer = 'L5';
            
        elseif d < 1200
            ua(i).layer = 'L6';
            
        end
        
    else
        ua(i).layer = 'NaN';
    end
    
end
