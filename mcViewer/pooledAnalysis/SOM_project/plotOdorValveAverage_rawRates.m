function ax = plotOdorValveAverage_rawRates(indices, valves, h)
% plots an average of clusters selected by indices (i.e.
% clusters(indices(i)
% for every cluster the average over valves = valves is normalized for both
% LED and ctl conditions by the ctl baseline firing rate

    global clusters
    
    if nargin < 3
        h = figure;
    end
    
    nBins = clusters(indices(1)).analysis.SpikesByCycleShifted.nBins;
    
    %initialize matrices,   nClusters x nBins
%     allratesCtl_bl=zeros(length(indices), nBins);
%     allratesCtl_odor=zeros(length(indices), nBins);
%     allratesLED_bl=zeros(length(indices), nBins);
%     allratesLED_odor=zeros(length(indices), nBins);

    allratesCtl_bl=[];
    allratesCtl_odor=[];
    allratesLED_bl=[];
    allratesLED_odor=[];


    
    for i = 1:length(indices)
        clust = indices(i);

        rateData = clusters(clust).analysis.SpikeRate.data;

        
        % gather average rates into nValves x nBins matrices
        ratesCtl_bl = [rateData(valves, 2).avg]; % column 2 is baseline
        ratesCtl_odor = [rateData(valves, 1).avg]; % column 1 is odor
        ratesLED_bl = [rateData(valves + 12, 2).avg];
        ratesLED_odor = [rateData(valves + 12, 1).avg];
        

       
        
        %average across valves
        ratesCtl_bl = mean(ratesCtl_bl', 1);
        ratesCtl_odor = mean(ratesCtl_odor', 1);
        ratesLED_bl = mean(ratesLED_bl', 1);
        ratesLED_odor = mean(ratesLED_odor', 1);
        
        %normalize by ctl baseline response
        normVal = mean(ratesCtl_bl);
        if normVal == 0
            continue
        end
        ratesCtl_bl = ratesCtl_bl / normVal;
        ratesCtl_odor = ratesCtl_odor / normVal;
        ratesLED_bl = ratesLED_bl / normVal;
        ratesLED_odor = ratesLED_odor / normVal;
        
        allratesCtl_bl(end + 1, :)=ratesCtl_bl;
        allratesCtl_odor(end + 1, :)=ratesCtl_odor;
        allratesLED_bl(end + 1, :)=ratesLED_bl;
        allratesLED_odor(end + 1, :)=ratesLED_odor;
    end
        
    times_bl = 5; %same for all clusters and valves
    times_odor = 7; %same for all clusters and valves

    allratesCtl_bl_avg = mean(allratesCtl_bl);
    allratesCtl_bl_std = std(allratesCtl_bl);
    allratesCtl_bl_N = size(allratesCtl_bl, 1);

    allratesCtl_odor_avg = mean(allratesCtl_odor);
    allratesCtl_odor_std = std(allratesCtl_odor);
    allratesCtl_odor_N = size(allratesCtl_odor, 1);

    allratesLED_bl_avg = mean(allratesLED_bl);
    allratesLED_bl_std = std(allratesLED_bl);
    allratesLED_bl_N = size(allratesLED_bl, 1);

    allratesLED_odor_avg = mean(allratesLED_odor);
    allratesLED_odor_std = std(allratesLED_odor);
    allratesLED_odor_N = size(allratesLED_odor, 1);        
        
        
    axes; hold on

    errorbar(times_bl, allratesCtl_bl_avg, allratesCtl_bl_std / sqrt(allratesCtl_bl_N), 'k');
    errorbar(times_bl, allratesLED_bl_avg, allratesLED_bl_std / sqrt(allratesLED_bl_N), 'r');        
    errorbar(times_odor, allratesCtl_odor_avg, allratesCtl_odor_std / sqrt(allratesCtl_odor_N), 'k');
    errorbar(times_odor, allratesLED_odor_avg, allratesLED_odor_std / sqrt(allratesLED_odor_N), 'r');                
        
        
    