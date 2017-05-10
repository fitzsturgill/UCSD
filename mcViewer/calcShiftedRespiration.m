function [shiftedTimes shiftedIndices] = calcShiftedRespiration(times, sampleRate, offset, xdata)
    
    shiftedTimes = zeros(size(times));
    shiftedIndices = zeros(size(times));    
    for i = 1:length(times)
        if i < length(times)
            newTime = times(i) + offset * (times(i+1) - times(i));
        else
            newTime = times(i) + offset * (times(i) - times(i - 1)); % for last respiration point extrapolate based upon previous
        end
        [newTime newIndex] = closestX(xdata, newTime);
%         if i < length(times)
%             shift = offset * (times(i+1) - times(i));
%         else
%             shift = offset * (times(i) - times(i - 1)); % for last respiration point extrapolate based upon previous
%         end
%         samples = round(shift / (1/sampleRate));  % ensure that shift doesn't fall between sample points
%         newTime = times(i) + samples * (1/sampleRate);
        shiftedTimes(i) = newTime;
        shiftedIndices(i) = newIndex;        
    end
%     shiftedIndices = find(ismember(xdata, shiftedTimes));
    if shiftedTimes(end) > xdata(end)
        shiftedIndices = shiftedIndices(1:end-1);
        shiftedTimes = shiftedTimes(1:end-1);
    end
    
    
    
function [newX newIndex] = closestX(xdata, x) % xdata is xdata, x is a scalar x location
    [B, IX] = sort(abs(xdata - x));
    newX = xdata(IX(1));
    newIndex = IX(1);