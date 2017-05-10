function ua = addDerivedValuesToOriRates(ua,r_flds)
% function ua = addDerivedValuesToOriRates(ua,r_flds)
%
%

% Created: SRO - 5/26/11

if nargin < 2 || isempty(r_flds)
    r_flds = {'stim','dFR'};
end

ua = computeDfr(ua);
ua = addSubtractModelToOriRates(ua,r_flds);
