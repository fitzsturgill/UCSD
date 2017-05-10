function t = sampleToTime(x,Fs)
%
%
%
%
%

% Created: SRO - 4/1/11


dt = 1/Fs;
t = dt*(x-1);
