function unit = populateUnit_oriRates(unit, curExpt, curTrodeSpikes, varargin)


expt = curExpt;
spikes = curTrodeSpikes;

% Set stimulus time window
w = expt.analysis.orientation.windows;

% Get fileInd for orientation files
fileInd = expt.analysis.orientation.fileInd;

% Filter spikes on files and unit assign
spikes = filtspikes(spikes,0,'fileInd',fileInd,'assigns',unit.assign);

% If spikes is empty, then fileInd was wrong (set fileInd trode sort)
if isempty(spikes.spiketimes)
    rdef = RigDefs;
    trodeInd = spikes.info.trodeInd;
    fileInd = expt.sort.trode(trodeInd).fileInds;
    spikes = loadvar(fullfile(rdef.Dir.Spikes,expt.sort.trode(trodeInd).spikesfile));
    spikes = filtspikes(spikes,0,'fileInd',fileInd,'assigns',unit.assign);
end

% Make stimulus struct for orientation
stim = makeStimStruct(expt,fileInd);

% Get cond struct
cond = expt.analysis.orientation.cond;

% Compute evoked firing rate
fr = computeResponseVsStimulus(spikes,stim,cond,w);

% Assign rate to unit struct
unit.oriRates = fr;


