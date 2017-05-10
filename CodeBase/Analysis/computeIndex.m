function index = computeIndex(data)
%
% INPUT
%   data: An N x 2 matrix, where each row is a different cell
%
% OUTPUT
%   index: 
%
%

% Created: 4/20/11 - SRO


index = (data(:,2) - data(:,1))./(data(:,2) + data(:,1));

