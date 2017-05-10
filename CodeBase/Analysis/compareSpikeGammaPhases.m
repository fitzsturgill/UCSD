function compareSpikeGammaPhases( expt, spikes, wv, filtA, filtB, gampercentile, numTracesToOverlay, useHilbert, timeWin1, timeWin2)
% INPUT: 
% expt - experiment struct
% spikes - spike struct
% wv - LFP waveforms associated w/ each spike in spikes (if empty it will be extracted)
% gampercentile - top <gampercentile>% of spikes ranked by gamma power will be kept
% numTracesToOverlay - how many traces should be displayed in overlays

% filtA - cell containing two nested cell arrays of property/value pairs to be passed to filtspikes,
% the first being filtered for an intersection of those properties, the
% second being filtered for a union, generating group A of spikes

% filtB - cell containing two nested cell arrays of property/value pairs to be passed to filtspikes,
% the first being filtered for an intersection of those properties, the
% second being filtered for a union, generating group B of spikes

% useHilbert - if 1, uses analytic signal found by hilbert transform to estimate
% phase and frequency, if 0, uses a zero-crossing method (assumes
% sinusoidal waveform, takes difference in closest peaks as period,
% 1/(peak1 - peak0) as frequency, (spike - peak0)/(peak1 - peak0) * 360 as
% phase)

if(nargin < 7)
    useHilbert = 0;
end
if(nargin < 9)
    timeWin1 = [];
end
if(nargin < 10)
    timeWin2 = [];
end
lowerbp = 20;
upperbp = 80;
if(isempty(filtA))
    filtA = {[], []};
end
if(isempty(filtB))
    filtB = {[], []};
end
    

hf.fig = figure;
set(hf.fig,'Visible','off','Position',[792 399 1056 724])
% figure schematic is on page 27 of lab notes (8/26/10)
hf.overlay.raw.ax(1) = axes('Parent', hf.fig);
hf.overlay.raw.ax(2) = axes('Parent', hf.fig);
hf.overlay.average.ax = axes('Parent', hf.fig);
hf.overlay.average.inset.ax = axes('Parent', hf.fig);
hf.hist.phase.subsamples.ax(1) = axes('Parent', hf.fig);
hf.hist.phase.subsamples.ax(2) = axes('Parent', hf.fig);
hf.hist.phase.single.ax(1) = axes('Parent', hf.fig);
hf.hist.phase.single.ax(2) = axes('Parent', hf.fig);
%hf.overlay.subsamplesbp.ax(1) = axes('Parent', hf.fig);
%hf.overlay.subsamplesbp.ax(2) = axes('Parent', hf.fig);
%hf.overlay.subsamples.ax(1) = axes('Parent', hf.fig);
%hf.overlay.subsamples.ax(2) = axes('Parent', hf.fig);
hf.overlay.singlebp.ax(1) = axes('Parent', hf.fig);
hf.overlay.singlebp.ax(2) = axes('Parent', hf.fig);
%hf.overlay.singlepow.ax(1) = axes('Parent', hf.fig);
%hf.overlay.singlepow.ax(2) = axes('Parent', hf.fig);
hf.hist.gammapower.ax(1) = axes('Parent', hf.fig);
hf.hist.gammapower.ax(2) = axes('Parent', hf.fig);
hf.hist.freq.ax(1) = axes('Parent', hf.fig);
%hf.hist.freq.ax(2) = axes('Parent', hf.fig);
 hf.tuning.ax = axes('Parent', hf.fig);
 hf.resp.A.ax(1) = axes('Parent', hf.fig);
 hf.resp.A.ax(2) = axes('Parent', hf.fig);
 hf.resp.B.ax(1) = axes('Parent', hf.fig);
 hf.resp.B.ax(2) = axes('Parent', hf.fig);
 hf.resp.legend.ax = axes('Parent', hf.fig);
% position_rectangle = [left, bottom, width, height];
hgs = 1/24; % horizontal and vertical grid spot sizes in relative coords
vgs = 1/18;
% raw overlay
set(hf.overlay.raw.ax(1), 'Position', [8 15 7 2].*[hgs vgs hgs vgs]);
set(hf.overlay.raw.ax(2), 'Position', [8 13 7 2].*[hgs vgs hgs vgs]);
% average overlay
set(hf.overlay.average.ax, 'Position', [16 13 6 4].*[hgs vgs hgs vgs]);
set(hf.overlay.average.inset.ax, 'Position', [(16+3+(3/8)) (13+(1/4)) (3*6/8) (3*5/8)].*[hgs vgs hgs vgs]);
% subsample phase hist
set(hf.hist.phase.subsamples.ax(1), 'Position', [8 2 6 3].*[hgs vgs hgs vgs]);
set(hf.hist.phase.subsamples.ax(2), 'Position', [8 5 6 1].*[hgs vgs hgs vgs]); % holds the reference cosine
% sweep by sweep phase dist
set(hf.hist.phase.single.ax(1), 'Position', [1 2 6 3].*[hgs vgs hgs vgs]);
set(hf.hist.phase.single.ax(2), 'Position', [1 5 6 1].*[hgs vgs hgs vgs]); % holds the reference cosine
% gamma bandpass singles
set(hf.overlay.singlebp.ax(1), 'Position', [8 10 7 2].*[hgs vgs hgs vgs]);
set(hf.overlay.singlebp.ax(2), 'Position', [8 8 7 2].*[hgs vgs hgs vgs]);
% singles power spectrum overlay
% set(hf.overlay.singlepow.ax(1), 'Position', [9 10+1/8 7 2*7/8].*[hgs vgs hgs vgs]);
% set(hf.overlay.singlepow.ax(2), 'Position', [9 8      7 2*7/8].*[hgs vgs hgs vgs]);
% singles total gamma power hist
set(hf.hist.gammapower.ax(1), 'Position', [16     8 3*(7/8) 4].*[hgs vgs hgs vgs]);
set(hf.hist.gammapower.ax(2), 'Position', [19+1/8 8 3*(7/8) 4].*[hgs vgs hgs vgs]);
% singles frequency hist / fvt display
set(hf.hist.freq.ax(1), 'Position', [16 2 6 4].*[hgs vgs hgs vgs]);
%set(hf.hist.freq.ax(1), 'Position', [16 2 6 2].*[hgs vgs hgs vgs]);
%set(hf.hist.freq.ax(2), 'Position', [16 4 6 2].*[hgs vgs hgs vgs]);
% rasters and psths
set(hf.resp.legend.ax, 'Position', [1 11.6 6 0.4].*[hgs vgs hgs vgs]); % raster color legend
% raster & psth A
set(hf.resp.A.ax(1), 'Position', [1 9 3 2.5].*[hgs vgs hgs vgs]); % raster
set(hf.resp.A.ax(2), 'Position', [1 8 3 1].*[hgs vgs hgs vgs]); % psth
% raster & psth B
set(hf.resp.B.ax(1), 'Position', [4 9 3 2.5].*[hgs vgs hgs vgs]); % raster
set(hf.resp.B.ax(2), 'Position', [4 8 3 1].*[hgs vgs hgs vgs]); % psth
% line orientation tuning
set(hf.tuning.ax(1), 'Position', [1 13 6 4].*[hgs vgs hgs vgs]);

if(~isfield(expt.analysis, 'orientation'))
    disp('expt.analysis does not have an orientation field!');
    disp('using bass'' fallback numbers'); % do not hardcode FIXIT
    expt.analysis.orientation.cond.type = [];
    expt.analysis.orientation.cond.values = {0};   
    w.spont = [0 0.5];
    w.stim = [1 2.5];
    w.on = [0.5 1];
    w.off = [3 3.5];
    expt.analysis.orientation.windows = w;
end
w = expt.analysis.orientation.windows;
% RIPPING ORIENTATION FIG FOR TUNING FIGURE -----------
varparam = expt.stimulus(spikes.fileInd(1)).varparam(1);
stim.type = varparam.Name;
if isfield(expt.stimulus(spikes.fileInd(1)).params,'oriValues')
    stim.values = expt.stimulus(spikes.fileInd(1)).params.oriValues;
else
    stim.values = varparam.Values;
end

cond = expt.analysis.orientation.cond;

for i = 1:length(stim.values)
    stim.code{i} = i;
end
allfr = computeResponseVsStimulus(spikes,stim,cond,w);
theta = stim.values';
hf.tuning.l = plotOrientTuning(allfr.stim,theta,hf.tuning.ax);
ylabel(hf.tuning.ax, 'spikes/s','FontSize',8)
xlabel(hf.tuning.ax, 'orientation','FontSize',8)
setTitle(hf.tuning.ax,'Orientation Tuning',8);


% END POORLY STOLEN CODE ------------

% spikes filtering stuff
wfield = fieldnames(w);
for(i = 1:length(wfield))
    spikes.(['window_', wfield{i}]) = zeros(length(spikes.spiketimes), 1);
    windowtimes = w.(wfield{i});
    winbegin = windowtimes(1);
    winend = windowtimes(2);
    windowvec = zeros(size(spikes.spiketimes));
    windowvec(( spikes.spiketimes >= winbegin ) & ( spikes.spiketimes <= winend )) = 1;
    spikes.(['window_', wfield{i}]) = windowvec;
end

if(~isempty(timeWin1))
    spikes.window_timeWin1 = zeros(size(spikes.spiketimes));
    spikes.window_timeWin1( ( spikes.spiketimes >= timeWin1(1) ) & ( spikes.spiketimes <= timeWin1(2)) ) = 1;    
end

if(~isempty(timeWin2))
    spikes.window_timeWin2 = zeros(size(spikes.spiketimes));
    spikes.window_timeWin2( ( spikes.spiketimes >= timeWin2(1) ) & ( spikes.spiketimes <= timeWin2(2)) ) = 1;    
end
   

if(~isempty(filtA{1}))    
    [st sortvector] = filtspikes(spikes, 0, filtA{1});
    wvt = wv(:, sortvector);
else
    st = spikes;
    wvt = wv;
end
if(~isempty(filtA{2}))
    [st sortvector] = filtspikes(st, 1, filtA{2});
    wvt = wvt(:, sortvector);
end

% bOR = filtB{1};
% filtB = filtB(2:end);
if(~isempty(filtB{1}))
    [sb sortvector] = filtspikes(spikes, 0, filtB{1});
    wvb = wv(:, sortvector);
else
    sb = spikes;
    wvb = wv;
end
if(~isempty(filtB{2}))
    [sb sortvector] = filtspikes(sb, 1, filtB{2});
    wvb = wvb(:, sortvector);
end
clear('wv', 'spikes', 'sortvector');

if(isempty(wvt) || isempty(wvb))
    if(isempty(wvt))
        error('Applying filter A resulted in an empty spike set.');
    end
    if(isempty(wvb))
        error('Applying filter B resulted in an empty spike set.');
    end
    return;
end
    
% end spike filtering stuff

% mark the orientations that correspond to each group
stimCondsA = unique(st.stimcond);
stimCondsB = unique(sb.stimcond);
for i = 1:length(stimCondsA)
    text(stim.values(stimCondsA(i)), 0, '\downarrow', 'Color', 'red', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Parent', hf.tuning.ax);
end
for i = 1:length(stimCondsB)
    text(stim.values(stimCondsB(i)), 0, '\uparrow', 'Color', 'blue', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Parent', hf.tuning.ax);
end
% end orientation marking

Fs = expt.files.Fs(1);
numsamples = size(wvt, 1);
% compute power: 
% multiply all by 4 since don't plot/use nyquist & DC bins anyway
% multiply by 1000 to get into whole numbers (of 10^-3 mV^2 ... or
% nanoWatt-Ohms)
wvt_pow = (abs(fft(wvt, [], 1)).^2 * (numsamples^(-2)) * 4)*10^3; 
wvb_pow = (abs(fft(wvb, [], 1)).^2 * (numsamples^(-2)) * 4)*10^3; 
gammaband_bins = unique(round((30:80)*( numsamples/Fs )))';
gampow_t = sum(wvt_pow(gammaband_bins, :), 1);
gampow_b = sum(wvb_pow(gammaband_bins, :), 1);

[ngpt xt] = hist(gampow_t);
[ngpb xb] = hist(gampow_b);
bar(hf.hist.gammapower.ax(1), xt, ngpt, 'red');
bar(hf.hist.gammapower.ax(2), xb, ngpb, 'blue');
hylim(1) = max(ngpt)*1.15;
hylim(2) = max(ngpb)*1.15;
hxlim = max([xt(:); xb(:)]);
set(hf.hist.gammapower.ax(1), 'XLim', [0 hxlim], 'YLim', [0, hylim(1)]);
set(hf.hist.gammapower.ax(2), 'XLim', [0 hxlim], 'YLim', [0, hylim(2)]);
xlabel(hf.hist.gammapower.ax(1), 'total \gamma power (10^{-3} mV{^2})');
%setTitle(hf.hist.gammapower.ax(1), 'Distribution of spike-associated LFP {\gamma}-band power');
if(gampercentile ~= 100)
    gampow = sort([gampow_t(:); gampow_b(:)], 'ascend');
    cutoffidx = round(length(gampow)*(100-gampercentile)*0.01);
    if(~cutoffidx) cutoffidx = 1; end    
    gammathresh = gampow(cutoffidx);
    disp(['Using a gamma power threshold of ', num2str(gammathresh), ' 10^-3 mV^2 (nanoWatt-Ohms), leaving the top ', num2str((1 - cutoffidx/length(gampow))*100), '% of spikes.'])
    st.powerthresh = zeros(size(st.spiketimes));
    sb.powerthresh = zeros(size(sb.spiketimes));
    st.powerthresh(gampow_t > gammathresh) = 1;
    sb.powerthresh(gampow_b > gammathresh) = 1;
    [st sortvector] = filtspikes(st, 0, 'powerthresh', 1);
    wvt = wvt(:, sortvector);
    assert(~any(gampow_t(sortvector) ~= gampow_t(gampow_t > gammathresh)), 'Sanity check failed.');
    gampow_t = gampow_t(sortvector);
    [sb sortvector] = filtspikes(sb, 0, 'powerthresh', 1);
    wvb = wvb(:, sortvector);
    assert(~any(gampow_b(sortvector) ~= gampow_b(gampow_b > gammathresh)), 'Sanity check failed.');
    gampow_b = gampow_b(sortvector);

    disp([num2str(size(wvt, 2)), ' spikes from Group A exceeded the threshold.']);
    disp([num2str(size(wvb, 2)), ' spikes from Group B exceeded the threshold.']);
    
    textyidx = find(diff(gammathresh - xt >= (xt(2)-xt(1))/2), 1);
    if(isempty(textyidx))
        textyidx = 1;
    end
    text(gammathresh, ngpt(textyidx), '\downarrow', 'HorizontalAlignment','center', 'Parent', hf.hist.gammapower.ax(1), 'FontSize', 14, 'color', 'green');    

    textyidx = find(diff(gammathresh - xb >= (xb(2)-xb(1))/2), 1);
    if(isempty(textyidx))
        textyidx = 1;
    end
    text(gammathresh, ngpb(textyidx), '\downarrow', 'HorizontalAlignment','center', 'Parent', hf.hist.gammapower.ax(2), 'FontSize', 14, 'color', 'green');    
end
clear('ngpt', 'ngpb', 'xt', 'xb');
clear('hylim', 'cutoffidx', 'gampow', 'gampow_t', 'gampow_b');

len_t = size(wvt, 2);
len_b = size(wvb, 2);
hlen_t = round(len_t/2);
hlen_b = round(len_b/2);

tdata = ((1:numsamples) - numsamples/2)/Fs * 1000; % time in milliseconds relative to spike
dispIntMed = find(diff(tdata < -45)):find(diff(tdata >= 45)); % medium duration display interval
dispIntSmall = find(diff(tdata < -15)):find(diff(tdata >= 15)); % small duration display interval



wvt = filtdata(wvt, Fs, 1, 'high');
wvb = filtdata(wvb, Fs, 1, 'high');


tidx = round(random('unif', ones([numTracesToOverlay, 1]), ones([numTracesToOverlay, 1])*len_t));
bidx = round(random('unif', ones([numTracesToOverlay, 1]), ones([numTracesToOverlay, 1])*len_b));
wvt2 = wvt(:, tidx);
wvb2 = wvb(:, bidx);

for(i = 1:numTracesToOverlay)
    line(tdata(dispIntMed), wvt2(dispIntMed, i), 'Parent', hf.overlay.raw.ax(1), 'Color', 'red');
    line(tdata(dispIntMed), wvb2(dispIntMed, i), 'Parent', hf.overlay.raw.ax(2), 'Color', 'blue');
end
set(hf.overlay.raw.ax(1), 'XTick', [-40 -20 0 20 40], 'XLim', [-45 45])
set(hf.overlay.raw.ax(2), 'XTick', [-40 -20 0 20 40], 'XLim', [-45 45], 'XTickLabel', {'-40ms', '-20ms', 'spike', '+20ms', '+40ms'})
setTitle(hf.overlay.raw.ax(1), 'Random sample of raw spike-centered LFP traces', 10, vgs/10);

wvt_mean = mean(wvt, 2);
wvb_mean = mean(wvb, 2);
plot(hf.overlay.average.ax, tdata(dispIntMed), wvt_mean(dispIntMed),'r', tdata(dispIntMed), wvb_mean(dispIntMed), 'b');
set(hf.overlay.average.ax, 'XTick', [-40 -20 0 20 40], 'XTickLabel', {'-40ms', '-20ms', 'spike', '+20ms', '+40ms'})
% bandpass and blow-up
wvt_mean = filtdata(wvt_mean, Fs, lowerbp, 'high');
wvt_mean = filtdata(wvt_mean, Fs, upperbp, 'low');
wvb_mean = filtdata(wvb_mean, Fs, lowerbp, 'high');
wvb_mean = filtdata(wvb_mean, Fs, upperbp, 'low');
plot(hf.overlay.average.inset.ax, tdata(dispIntSmall), wvt_mean(dispIntSmall), 'r', tdata(dispIntSmall), wvb_mean(dispIntSmall), 'b');
set(hf.overlay.average.inset.ax, 'XTick', [-10 0 10], 'XTickLabel', [], 'YTickLabel', []);
setTitle(hf.overlay.average.ax, 'Spike-triggered average of LFP', 10, vgs/10);
clear('wvt_mean', 'wvb_mean');

% SUBSAMPLING -- TRACES OVERLAY
numSubsamples = 50;
wvt_sampmean = nan(size(wvt, 1), numSubsamples);
wvb_sampmean = nan(size(wvb, 1), numSubsamples);
for(i = 1:numSubsamples)
    stidx = round(random('unif', ones([hlen_t, 1]), ones([hlen_t, 1])*len_t));
    sbidx = round(random('unif', ones([hlen_b, 1]), ones([hlen_b, 1])*len_b));
    wvt_sampmean(:, i) = mean(wvt(:, stidx), 2);
    wvb_sampmean(:, i) = mean(wvb(:, sbidx), 2);
end
%plot(hf.overlay.subsamples.ax(1), wvt_sampmean(:, 1:numTracesToOverlay));
%plot(hf.overlay.subsamples.ax(2),wvb_sampmean(:, 1:numTracesToOverlay));

% SUBSAMPLING -- PHASES HISTOGRAM ----
wvt_sampmean = filtdata(wvt_sampmean, Fs, 20, 'high');
wvb_sampmean = filtdata(wvb_sampmean, Fs, 20, 'high');
wvt_sampmean = filtdata(wvt_sampmean, Fs, 80, 'low');
wvb_sampmean = filtdata(wvb_sampmean, Fs, 80, 'low');

%plot(hf.overlay.subsamplesbp.ax(1), wvt_sampmean(:, 1:numTracesToOverlay));
%plot(hf.overlay.subsamplesbp.ax(2), wvb_sampmean(:, 1:numTracesToOverlay));

windowTimeInSamples = round(0.018*Fs); % 18ms in samples, window used for peak-to-peak estimation of phase (not for hilbert)

phase_t = findSpikePhaseFromLFPWin(wvt_sampmean, windowTimeInSamples, useHilbert);
phase_b = findSpikePhaseFromLFPWin(wvb_sampmean, windowTimeInSamples, useHilbert);

unitPhaseDistPlot([phase_t(:), phase_b(:)], hf.hist.phase.subsamples.ax(1), hf.hist.phase.subsamples.ax(2));
setTitle(hf.hist.phase.subsamples.ax(2), 'Distribution of subsampled STA LFP \gamma phases', 10, vgs/10);
clear('wvt_sampmean', 'wvb_sampmean');
% END SUBSAMPLING

% ------------------------------------------
% SWEEP BY SWEEP GAMMA PSD VARIATION -------
% for(i = 1:numTracesToOverlay)
%     line(gammaband_bins*(Fs/numsamples), wvt_pow(gammaband_bins, tidx(i)), 'Parent', hf.overlay.singlepow.ax(1), 'Color', 'red');
%     line(gammaband_bins*(Fs/numsamples), wvb_pow(gammaband_bins, bidx(i)), 'Parent', hf.overlay.singlepow.ax(2), 'Color', 'blue');
% end
% %plot(hf.overlay.singlepow.ax(1), repmat(gammaband_bins*( Fs/size(wvt, 1)), [1 length(tidx)]), wvt_pow(gammaband_bins, tidx));
% %plot(hf.overlay.singlepow.ax(2), repmat(gammaband_bins*( Fs/size(wvt, 1)), [1 length(bidx)]), wvb_pow(gammaband_bins, bidx));
% set(hf.overlay.singlepow.ax(1), 'XLim', [30, 80], 'XTick', []);
% set(hf.overlay.singlepow.ax(2), 'XLim', [30, 80]);
% xlabel(hf.overlay.singlepow.ax(2), 'frequency (hz)');
% ylabel(hf.overlay.singlepow.ax(2), 'power');

% -------------------------------------------
% SWEEP BY SWEEP PHASE VARIATION ------------
clear lastpeak nextpeak nextmin pi_t t0_t t1_t phase_t hwvt;
lowerbp = 20;
upperbp = 80;
wvt = filtdata(wvt, Fs, lowerbp, 'high');
wvb = filtdata(wvb, Fs, lowerbp, 'high');
wvt = filtdata(wvt, Fs, upperbp, 'low');
wvb = filtdata(wvb, Fs, upperbp, 'low');

for(i = 1:numTracesToOverlay) % overlay same traces as in raw, but now bandpassed
    line(tdata, wvt(:, tidx(i)), 'Parent', hf.overlay.singlebp.ax(1), 'Color', 'red');
    line(tdata, wvb(:, bidx(i)), 'Parent', hf.overlay.singlebp.ax(2), 'Color', 'blue');
end
set(hf.overlay.singlebp.ax(1), 'XLim', [-100 100], 'XTick', -80:40:80);
set(hf.overlay.singlebp.ax(2), 'XLim', [-100 100], 'XTick', -80:40:80, 'XTickLabel', {'-80ms', '-40ms', 'spike', '+40ms', '+80ms'});
setTitle(hf.overlay.singlebp.ax(1), ['Bandpassed: ', num2str(lowerbp), '-', num2str(upperbp), 'hz'], 10, vgs/10);


[phase_t freq_t] = findSpikePhaseFromLFPWin(wvt, windowTimeInSamples, useHilbert);
[phase_b freq_b] = findSpikePhaseFromLFPWin(wvb, windowTimeInSamples, useHilbert);
st.spikephases = phase_t;
sb.spikephases = phase_b;


unitPhaseDistPlot(phase_t(:), hf.hist.phase.single.ax(1), hf.hist.phase.single.ax(2)); % have to do these in separate calls because length(phase_b) ~= length(phase_t)
unitPhaseDistPlot(phase_b(:), hf.hist.phase.single.ax(1), hf.hist.phase.single.ax(2)); % will automatically make the appended data blue
setTitle(hf.hist.phase.single.ax(2), 'Distribution of single spike \gamma phases', 10, vgs/10);
xlabel(hf.hist.phase.single.ax(1), 'Phase ({\circ})'); ylabel(hf.hist.phase.single.ax(1), '# spikes / total');

fvt_t = [];
fvt_b = [];
if(useHilbert)
    fvt_t = freq_t;
    freq_t = median(freq_t, 1);
    fvt_b = freq_b;
    freq_b = median(freq_b, 1);
end
unitFreqDistPlot(freq_t, hf.hist.freq.ax(1), [], fvt_t, 'red');
unitFreqDistPlot(freq_b, hf.hist.freq.ax(1), [], fvt_b, 'blue');
setTitle(hf.hist.freq.ax(1), 'Distribution of LFP \gamma oscillation frequencies', 10, vgs/10);
%unitFreqDistPlot(freq_t, hf.hist.freq.ax(1), hf.hist.freq.ax(2), fvt_t, 'red');
%unitFreqDistPlot(freq_b, hf.hist.freq.ax(1), hf.hist.freq.ax(2), fvt_b, 'blue');
disp(['Group A: Minimum freq = ', num2str(min(freq_t)), ', Maximum freq = ', num2str(max(freq_t))]);
disp(['Group B: Minimum freq = ', num2str(min(freq_b)), ', Maximum freq = ', num2str(max(freq_b))]);

figure(hf.fig); % raster uses gcf so we must focus the figure (in case we are debugging later)
[hA{1}] = psth(st,50,hf.resp.A.ax(2),1);
[hB{1} hB{2}] = psth(sb,50,hf.resp.B.ax(2),1);
raster(st, hf.resp.A.ax(1), 1);
[hB{3} hB{4}] = raster(sb, hf.resp.B.ax(1), 1);
set(hA{1}, 'Color', 'red');
set(hB{1}, 'Color', 'blue');
ylabel(hB{4}, '');
ylabel(hB{2}, '');

makePhaseColorLegend(hf.resp.legend.ax);

set(hf.fig, 'Visible', 'on');

