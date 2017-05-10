function [Ravg R] = mcCorr(unit1, unit2, cycle, x1, x2, binSize, equalize)
    % Ravg = average pearson's correlation coefficient between units
    % R = vector of correlation coefficients for each trial, may equal less
    % than total # of trials if there are fewer than 2 spikes in a trial
    % for one or another of the units
    
    % unit1 and unit2 are 2 element vectors of form: [trode cluster]
    % cycle is cycle
    % x1 and x2 are boundaries of time window
    % binSize: is size in msec of bins for instantaneous spike rate
    % determination (doesn't really affect results)
    % equalize: if == 1, spikes are randomly removed from trial with greater number of spikes such that spike rates are equalized 
    global state
    
    % set Defaults and initialize variables
    if nargin < 6 % don't think I need this...
        binSize = 100;  % 100msec bins for instantaneous spike rate determination
    end
    
    if nargin < 7
        equalize = 0;
    end
    
   
    % get cycle vector
    trials = mcTrialsByCycle(cycle);

    R=[];
    for i = 1:length(trials)
        trial = trials(i);
        times1 = state.mcViewer.trode(unit1(1)).cluster(unit1(2)).spikeTimes{1, trial};
        times2 = state.mcViewer.trode(unit2(1)).cluster(unit2(2)).spikeTimes{1, trial};
        if equalize
            L1 = length(times1);
            L2 = length(times2);
            Ldiff = abs(L1 - L2);
                if L1 > L2 
                    [B, IX] = sort(rand(1, L1)); % IX is a random series of indices
                    IX = IX(1:L2);
                    times1 = sort(times1(IX)); %take random indices of times1 and then sort back to ascending order
                elseif L1 < L2
                    [B, IX] = sort(rand(1, L2));
                    IX = IX(1:L1);
                    times2 = sort(times2(IX));
                end
        end
                
        rates1 = histc(times1, x1:binSize:x2) ./ binSize .* 1000;
        rates2 = histc(times2, x1:binSize:x2) ./ binSize .* 1000;        


        if length(times1) > 1 && length(times2) > 1
            thisR = corr(rates1', rates2');
            R = [R thisR];
        end
    end
    Ravg = mean(R(~isnan(R)));


    
%     function [Ravg R] = mcCorr(unit1, unit2, cycle, x1, x2) %, Fs)
%     % C is a vector of the raw crosscorreltion
%     % shiftC is the shift predictor
%     % rawC is the correted crosscorrelation
%     % lags are the x values for the crosscorrelation
%     
%     % unit1 and unit2 are 2 element vectors of form: [trode cluster]
%     % cycle is cycle
%     % x1 and x2 are boundaries of time window
%     global state
%     
%     % set Defaults and initialize variables
% %     if nargin < 6 % don't think I need this...
% %         Fs = 0.5;
% %     end
%     
%    
%     % get cycle vector
%     trials = mcTrialsByCycle(cycle);
%     
% 
% %%     % calculate Pearson's correlation coefficients 
% 
%     [rawC, lags] = corrFromTrials(trials, trials);
%     if isempty(find(lags))
%         return
%     end
% %% Next assemble shift predictor xcorr
%     shiftC = zeros(1, 2*Fs*maxLag + 1);
%     for i = 1:length(trials)-1
%         shiftTrials = circshift(trials, [0 i]);
%         [thisC, thisLags] = corrFromTrials(trials, shiftTrials);
%         shiftC = shiftC + thisC;
%     end
%     shiftC = shiftC ./ (length(trials) - 1);
%     
% %% Now assemble corrected xcorr by subracting shift predictor from raw
%     C = rawC - shiftC;
%     
%     
% %% nested function to perform xcorr by blocks of trials    
%     function [thisC, thisLags] = corrFromTrials(trials1, trials2)
%         thisC = zeros(1, 2*Fs*maxLag + 1);
%         thisLags = zeros(1, 2*Fs*maxLag + 1);
%         for I = 1:length(trials)
%             trial1 = trials1(I);
%             trial2 = trials2(I);
% 
%             times1 = state.mcViewer.trode(unit1(1)).cluster(unit1(2)).spikeTimes{1, trial1};
%             times1 = times1(times1 > x1 & times1 < x2);
%             times2 = state.mcViewer.trode(unit2(1)).cluster(unit2(2)).spikeTimes{1, trial2};
%             times2 = times2(times2 > x1 & times2 < x2);
%             
%             
%             if length(times1) > 1 && length(times2) > 1
%                 [preC, thisLags] = pxCorr(times1, times2, Fs, maxLag);
%                 thisC = thisC + preC;
%             end
%         end
%     end
% end
% 





