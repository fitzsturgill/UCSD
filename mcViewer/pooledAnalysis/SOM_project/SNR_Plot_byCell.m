function dPrime=SNR_Plot_byCell(indices, nCycles, cycles, odorThresh)

    % assumes that there are n cycles
    % cycles 1:n/2 correspond to ctl and n/2+1:n correspond to LED
    
    global clusters
    
    dPrime = [];
    zScores_odor = [];
    zScores_LED = [];
    for i = 1:length(indices)
        cluster = indices(i);
        
        ctlCyc = cycles;
        LEDCyc = nCycles/2 + cycles;
        % classify cluster according to direction of LED effect and size of
        % effect (by averaging z scores)
        [dp zs zsL] = getDPrime(clusters(cluster).analysis.SpikeRate.data, ctlCyc, LEDCyc);

        % only accept odor/cell pairs with odor z score values above
        % odorThresh
        responses = zs > odorThresh;
        responses = find(responses);
        dp = dp(responses, :);
        zs = zs(responses, 1);
        zsL = zsL(responses, 1);
        
        % now average together for each cell prior to concatenation
        if ~isempty(dp)
            dPrime = vertcat(dPrime, mean(dp, 1));
            zScores_odor = vertcat(zScores_odor, mean(zs));
            zScores_LED = vertcat(zScores_LED, mean(zsL));
        end
    end
    

    [ctl_sorted ctl_index]=cum(dPrime(:,1));
    [LED_sorted LED_index]=cum(dPrime(:,2));    
    figure; hold on
    plot(ctl_sorted, ctl_index, '-k');
    plot(LED_sorted, LED_index, '-r');
    figure; hold on
    dPrime_sem = std(dPrime) ./ sqrt(size(dPrime, 1));
    errorbarxy(mean(dPrime(:,1)), mean(dPrime(:,2)), dPrime_sem(1,1), dPrime_sem(1,2)); hold on
    scatter(dPrime(:,1), dPrime(:,2));    
    setXYsameLimit;
    addUnityLine;
    
    % now plot delta SNR vs LED z score
    deltaSNR = dPrime(:,1) - dPrime(:,2);
    figure; scatter(zScores_LED, deltaSNR);
    xlabel('LED Z Score');
    ylabel('delta SNR');
    figure; hist(deltaSNR);
    ylabel('delta SNR');
%     figure; hist(zScores_odor, 50);
end

function [dPrimeArray zScores_odor zScores_LED] = getDPrime(data, ctlCyc, LEDCyc)
    % remember for SpikeRate field, basline period is second column, odor
    % period is first column
    ratesCtl = [vertcat(data(ctlCyc, 2).avg) vertcat(data(ctlCyc, 1).avg)];
    varCtl = [vertcat(data(ctlCyc, 2).std) vertcat(data(ctlCyc, 1).std)].^2;    
    ratesLED = [vertcat(data(LEDCyc, 2).avg) vertcat(data(LEDCyc, 1).avg)];
    varLED = [vertcat(data(LEDCyc, 2).std) vertcat(data(LEDCyc, 1).std)].^2;
    
    dControl = (ratesCtl(:,2) - ratesCtl(:,1)) ./ (mean(varCtl, 2)).^(1/2);
    dLED = (ratesLED(:,2) - ratesLED(:,1)) ./ (mean(varLED, 2)).^(1/2);    
    dPrimeArray = [dControl dLED];
    positives = dPrimeArray > 0;
    posIndices = positives(:,1) .* positives(:,2); % only choose cell-odor pairs for which both ctl and LED odor responses are positive
    posIndices = find(posIndices);
    dPrimeArray = dPrimeArray(posIndices, :);    
    
    % also return odor response Z Score values
    stdCtl = vertcat(data(ctlCyc, 2).std);
    zScores_odor = (ratesCtl(:,2) - ratesCtl(:,1)) ./ stdCtl;
    zScores_odor = zScores_odor(posIndices, 1);
    % also return LED Z Scores for each odor/cell pair
    zScores_LED = (ratesLED(:,2) - ratesCtl(:,2)) ./ vertcat(data(ctlCyc, 1).std);
    zScores_LED = zScores_LED(posIndices, 1);
end

    