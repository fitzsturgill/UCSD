function sampleSizes = makeFDRScatterPlot(spontData, maxN)
    % this is specific to a structure that I manually created importing 
    % charge per respiration from igor
    
    % this generates a scatter plot with significant cells color coded
    % sig. cells are IDd by False Discovery Rate procedure
    % initialize variables
    alpha = 0.05; % critical value
    if nargin < 2 % maxN default = 0, which means that it won't subsample for kstests...
        maxN = 0; % for FDR take at most this number of points from every condtion and cell to minimize sample size differences
    end
    nExp = length(spontData);
    excAvg = zeros(nExp, 2);
    inhAvg = zeros(nExp, 2);    
    excP = zeros(nExp, 1);
    inhP = zeros(nExp, 1);    
    labels = cell(nExp, 1);
    % gather p values and averages
    
    % kludge
    sampleSizes = zeros(nExp, 4);
    for i=1:length(spontData)
        % first excitation
        if maxN == 0
            [h, p] = kstest2(spontData(i).exc_ctl, spontData(i).exc_LED);            
        else
            [h, p] = specialTest(spontData(i).exc_ctl, spontData(i).exc_LED, maxN);
        end
        excP(i) = p;
        excAvg(i, 1) = mean(spontData(i).exc_ctl);
        excAvg(i, 2) = mean(spontData(i).exc_LED);
        excAvg = abs(excAvg);
        
        sampleSizes(i, 1) = length(spontData(i).exc_ctl);
        sampleSizes(i, 2) = length(spontData(i).exc_LED);
        
        % then inhibition

        if maxN == 0
            [h, p] = kstest2(spontData(i).inh_ctl, spontData(i).inh_LED);            
        else
            [h, p] = specialTest(spontData(i).inh_ctl, spontData(i).inh_LED, maxN);
        end
        inhP(i) = p;
        inhAvg(i, 1) = mean(spontData(i).inh_ctl);
        inhAvg(i, 2) = mean(spontData(i).inh_LED);    
        
        sampleSizes(i, 3) = length(spontData(i).inh_ctl);
        sampleSizes(i, 4) = length(spontData(i).inh_LED);        
        
        % and label
        labels{i} = spontData(i).label;
    end
    
    % perform FDR procedure for excitation
    [sorted, indices] = sort(excP, 'descend');
    elements = nExp:-1:1;
    elements = elements';
    CrV = ones(nExp, 1) * alpha;
    CrV = CrV .* (elements ./ nExp);
    
    
    % step through sorted testing whether null hypothesis is rejected
    exc_H0 = sorted < CrV;
    % find the first rejected null hypothesis and reject the remaining as
    % well
    exc_H0(find(exc_H0, 1):end) = 1;
    % restore original sorting
%     rate_odor_CrV = CrV(indices);
%     rate_odor_H0 = rate_odor_H0(indices);
    unsorted=1:length(indices);
    indices2(indices)=unsorted;
    exc_CrV = CrV(indices2);
    exc_H0 = exc_H0(indices2);
    sorted=sorted(indices2);
    
    % make excitation scatter plot
    fig = figure('Name', 'Excitation: Spontaneous');
    colormap(winter);
    scatter(excAvg(:,1), excAvg(:,2), [],exc_H0);
    setXYsameLimit;
    addUnityLine;
    xlabel('Ctl: Charge/resp.');
    ylabel('LED: Charge/resp.');
    
    
    % perform FDR procedure for inhibition
    [sorted, indices] = sort(inhP, 'descend');
    elements = nExp:-1:1;
    elements = elements';    
    CrV = ones(nExp, 1) * alpha;
    CrV = CrV .* (elements ./ nExp);
    
    
    % step through sorted testing whether null hypothesis is rejected
    inh_H0 = sorted < CrV;
    % find the first rejected null hypothesis and reject the remaining as
    % well
    inh_H0(find(inh_H0, 1):end) = 1;
    % restore original sorting
%     rate_odor_CrV = CrV(indices);
%     rate_odor_H0 = rate_odor_H0(indices);
    unsorted=1:length(indices);
    indices2(indices)=unsorted;
    inh_CrV = CrV(indices2);
    inh_H0 = inh_H0(indices2);
    sorted=sorted(indices2);
    
    % make inhibition scatter plot
    fig = figure('Name', 'Inhibition: Spontaneous');
    colormap(winter);
    scatter(inhAvg(:,1), inhAvg(:,2), [], inh_H0);
    setXYsameLimit;
    addUnityLine;
    xlabel('Ctl: Charge/resp.');
    ylabel('LED: Charge/resp.'); 
end

function [h, p] = specialTest(A,B,maxN)
    % take at most maxN points randomly for A and B to increase sample
    % size equalization amongst different cells and conditions for FDR
    % procedure
    scramble = rand(size(A, 1), 1);
    [sorted, indices] = sort(scramble);
    n = min(size(A, 1), maxN);
    A = A(indices(1:n));
    
    scramble = rand(size(B, 1), 1);
    [sorted, indices] = sort(scramble);
    n = min(size(B, 1), maxN);
    B = B(indices(1:n));   
    
  
    [h, p] = kstest2(A, B);
end
    
    