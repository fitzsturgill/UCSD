function waveform = computeSpikeParameters(wv,xtime)
% function waveform = computeSpikeParameters(wv,xtime)
%
% INPUT:
%   wv:
%   xtime:
%
% OUTPUT:
%   params: struct containing spikes waveform parameters

% Created: SRO - 4/20/11

if nargin < 2
    % Assume sample rate of 32k
    dt = 1/32000;
    xtime = 0:dt:dt*length(wv)-dt;
    
end


if ~isempty(wv)
    
    % Find trough amplitude
    [trough t_loc] = min(wv);
    trough = -trough;
    
    % Find peak amplitude
    [peak p_loc] = max(wv(t_loc:end));
    p_loc = p_loc + t_loc - 1;
    
    % Compute trough:peak amplitude
    tp = trough/peak;
    
    % Compute time from trough to peak
    tp_time = xtime(p_loc) - xtime(t_loc);
    
    % Find zero crossing after peak
    r_base = crossing(wv(p_loc:end));
    r_base = r_base + p_loc - 1;
    if isempty(r_base)
        r_base = length(wv);
    else
        r_base = r_base(1);
    end
    
    % Compute spike width
    width = xtime(r_base) - xtime(t_loc);
    
    % Assign output struct
    waveform.trough = trough;
    waveform.peak = peak;
    waveform.amplitude = trough + peak;
    waveform.troughpeakratio = tp;
    waveform.tp_time = tp_time;
    waveform.width = width;
    waveform.avgwave = wv;
    waveform.xtime = xtime';
    
else
    
    % Assign output struct
    waveform.trough = NaN;
    waveform.peak = NaN;
    waveform.amplitude = NaN;
    waveform.troughpeakratio = NaN;
    waveform.tp_time = NaN;
    waveform.width = NaN;
    waveform.avgwave = NaN;
    waveform.xtime = NaN';
    
end



