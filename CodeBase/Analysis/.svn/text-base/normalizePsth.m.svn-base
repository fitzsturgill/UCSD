function nPsthMat = normalizePsth(psthMat,centers,w,normType)
% function nPsthMat = normalizePsth(psthMat,centers,w,normType)
%
% INPUT
%   psthMat: PSTH matrix
%   centers: Center of bins in seconds
%   w: Window to find peak for normalization
%   normType: 'max' or 'mean'
%
% OUTPUT
%   nPsthMat: Normalized PSTH matrix of same size as input


if nargin < 4
    normType = 'max';
end

% Determine index range to normalize to
k = (centers >= w(1)) & (centers <= w(2));

for i = 1:size(psthMat,3)
    switch normType
        case 'max'
            nVal = max(psthMat(k,1,i));
        case 'mean'
            nVal = mean(psthMat(k,1,i));
    end
    psthMat(:,:,i) = psthMat(:,:,i)/nVal;  
end

nPsthMat = psthMat;
