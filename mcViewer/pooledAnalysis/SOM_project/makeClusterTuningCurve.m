function makeClusterTuningCurve(index)
    global clusters
    
    data = clusters(index).analysis.SpikeRate.data;
    
    ncycles = size(data, 1);   
    cycles = [2:ncycles/2 ncycles/2+2:ncycles];  %omit air trial
    ncycles = length(cycles); % update ncycles to reflect exclution of air trial
    avgRates = reshape([data(cycles,1).avg], ncycles/2, 2);
    semRates = reshape([data(cycles,1).sem], ncycles/2, 2);
    
    [sorted, key] = sort(avgRates(:, 1));
    odds = key(1:2:end);
    evens = key(2:2:end);
    keyBlended = [odds ; flipud(evens)]; % key reshuffled to make pseudo-tuning curve
    
    % convert linear indexes from single column (ctl condition), to
    % subscript indexes for both ctl and LED columns
    keyBlended = sub2ind(size(avgRates), repmat(keyBlended, 1, 2), cat(2, ones(size(sorted)), ones(size(sorted)) + 1));
    
    % sort avg rates and SEMs according to keyBlended
    avgRates = avgRates(keyBlended);
    semRates = semRates(keyBlended);
    
    figure; 
    h = errorbar(avgRates, semRates);
    set(gca, 'TickDir', 'out');
    set(h(1), 'Color', 'k');
    set(h(2), 'Color', 'r');
    textBox({[clusters(index).experiment],...
    [clusters(index).trodeName ' C' num2str(clusters(index).cluster) ' I' num2str(index)]...
    }, [], [], 8);
    
    