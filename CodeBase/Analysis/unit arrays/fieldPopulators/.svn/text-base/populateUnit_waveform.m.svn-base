function unit = populateUnit_waveform(unit, curExpt, curTrodeSpikes,varargin)
%
%
%
%
%

% Created: SRO - 4/26/11


expt = curExpt;
spikes = curTrodeSpikes;

% Filter spikes on assign
spikes = filtspikes(spikes,0,'assigns',unit.assign);

% Compute average spike waveform
[avgwv xtime maxch] = computeAvgSpikeWaveform(spikes,expt);

% Extract spike parameters
waveform = computeSpikeParameters(avgwv(:,maxch),xtime);

% Assign output
unit.waveform = waveform; 