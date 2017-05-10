function fr = computeBlankResponse(spikes,params,cond,expt)


% Analyze if blank stimulus used
if isfield(params,'addBlank')
    addBlank = params.addBlank;
else
    addBlank = 0;
end

% Filter spikes on blank stimulus
blankStimCond = length(params.oriValues) + 1;
spikes = filtspikes(spikes,0,'stimcond',blankStimCond);

% Define LED window
w = expt.analysis.orientation.windows.ledon;

% Compute firing rate for each LED value
for i = 1:length(cond.values)
    if strcmp(cond.type,'led')
        spikes.tempfield = spikes.led;
        spikes.tempfield = compareDouble(spikes.tempfield,cond.values{i});
        spikes.sweeps.tempfield = spikes.sweeps.led;
        spikes.sweeps.tempfield = compareDouble(spikes.sweeps.tempfield,cond.values{i});
        tempspikes = filtspikes(spikes,0,'tempfield',1);
    else
        tempspikes = filtspikes(spikes,0,cond.type,cond.values{i});
    end
    [fr(i,1) fr(i,2)] = computeFR(tempspikes,w);  % average and SEM
end
