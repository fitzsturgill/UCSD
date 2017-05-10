function [davg dsem] = avgSem(data,dim)
% function [davg dsem] = avgSem(data,dim)
%
% INPUT
%   data: Matrix of data to be averaged
%   dim: Dimension to average along
%
% OUTPUT
%   davg: Average vector
%   dsem: Standard error of the mean vector

% Created: SRO - 5/17/11


if nargin < 2
    dim = 1;
end

if ~any(isnan(data))
    davg = mean(data,dim);
    n = sqrt(size(data,dim));
    dsem = std(data,[],dim)./n;
else
    disp('Using nanmean')
    davg = nanmean(data,dim);
    
    % Need to remove NaN columns
    n = sum(~isnan(data),dim);
    if dim == 1
        n = n';
    end
    dsem = nanstd(data,[],dim)./sqrt(n);
end

