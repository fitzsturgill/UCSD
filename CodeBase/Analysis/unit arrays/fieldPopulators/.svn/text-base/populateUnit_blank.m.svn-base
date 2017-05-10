function unit = populateUnit_blank(unit, curExpt, curTrodeSpikes,varargin)
%
%
%
%
% Currently this code assumes that the stimulus used is drifting gratings
% of various orientations. In future, broaden to deal with more diverse
% stimulus (e.g. contrast, spatial frequency); 

% Created: SRO - 4/26/11



% Determine whether blank stimulus was given
fileInd = expt.analysis.orientation.fileInd(1);
params = expt.stimulus(fileInd).params;

if isfield(params, 'addBlank')
    blank.addBlank = params.addBlank;
else
    blank.addBlank = 0; 
end

% Determine stimcode for blank stimulus
nOri = params.oriSteps;
blankcode = nOri + 1;

% 
