function unit = populateUnit_osi(unit, curExpt, curTrodeSpikes,varargin)


% Get theta
theta = unit.oriTheta';

if isfield(unit,'manipulation')
    manipulation = unit.manipulation;
    switch manipulation
        case 'Arch'
            % Get response in stim window
            r = unit.oriRates.stim;
            % Subtract spontaneous activity
            rs = unit.oriRates.stim - unit.oriRates.spont;
        case 'ChR2'
            % Get response in LED window
            r = unit.oriRates.ledon;
            rs = unit.oriRates.ledon - unit.oriRates.spont;
    end
else
    % Get response in LED window
    r = unit.oriRates.ledon;
    rs = unit.oriRates.ledon - unit.oriRates.spont;
end

if any(isnan(r))
    unit.osi(1) =  nan;
    unit.osi(2) =  nan;
else
    
    for i = 1:size(r,2)
        % osi(1) = 1-circular variance
        unit.osi(i,1) = orientTuningMetric(r(:,i),theta);
    end
    
    for i = 1:size(rs,2)
        unit.osi(i,2) = orientTuningMetric(rs(:,i),theta);
    end
end


