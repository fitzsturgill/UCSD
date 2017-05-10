function modulation = calcOdorModulation(indices)
% for every cluster, calculate odor modulation ratios for ctl and LED
% conditions
% odor mod = FR max odor / FR air trial
% returns a length(indices) X 2 matrix, first column, control, second
% column LED values

% assumes that cycle order corresponds to N odors with first odor being a
% "null" odor or air trial, followed by the same N odors + LED

    global clusters
    
    modulation = zeros(length(indices), 2);
    
    for i=1:length(indices)
        clust = indices(i);
        data = clusters(clust).analysis.SpikeRate.data;
        odor  = twoColumns([data(:, 1).avg]);
%         odorMod = (max(odor(2:end, :)) ./ odor(1, :));
        odorMod = (max(odor(2:end, :)) - odor(1, :)) ./ (max(odor(2:end, :)) + odor(1, :));        
        if any(isinf(odorMod)) 
            % if there is a FR of 0 for the null odor, use the average of the spontaneous period 
            odorMod = max(odor(2:end, :)) ./ mean(twoColumns([data(:, 2).avg]));
%             odorMod = max(odor(2:end, :)) ./ mean(twoColumns([data(:, 2).avg]));
        odorMod = (max(odor(2:end, :)) - mean(twoColumns([data(:, 2).avg]))) ./ (max(odor(2:end, :)) + mean(twoColumns([data(:, 2).avg])));    
        end
        modulation(i, :) = odorMod;
    end
end

function out = twoColumns(m)
    % returns 2 column matrix
    m = reshape(m', length(m) / 2, 2);
    out = m;
end