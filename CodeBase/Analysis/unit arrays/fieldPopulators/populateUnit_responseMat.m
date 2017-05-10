function unit = populateUnit_responseMat(unit, curExpt, curTrodeSpikes,varargin)

% Abbreviate
expt = curExpt;
s = curTrodeSpikes;

% Filter spikes on assign and files used for orientation analysis
fileInd = expt.analysis.orientation.fileInd;
w = expt.analysis.orientation.windows;
s = filtspikes(s,0,'fileInd',fileInd,'assigns',unit.assign);

% Set cond struct
cond = expt.analysis.orientation.cond;

% Set stimulus values and codes
stim = makeStimStruct(expt,fileInd);

% Compute firing rate as a function of stimulus and LED
fr = computeResponseVsStimulus(s,stim,cond,w);

unit.responseMat = fr; 