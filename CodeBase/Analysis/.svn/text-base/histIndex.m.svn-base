function histIndex(data)
%
%
%
%



% Compute index (r1-r2)/(r1+r2)
indVal = (data(:,2)-data(:,1))./(data(:,2)+data(:,1));
indVal = indVal(indVal > -1);
indVal = indVal(indVal < 1);
length(indVal)

% Compute percent change
normVal = (data(:,2)-data(:,1))./data(:,1);
% normVal = normVal(normVal < 4);
% normVal = normVal(normVal > -4);
length(normVal)

% Make histogram of values
figure; hist(indVal,20);
line('Parent',gca,'XData',mean(indVal),'YData',0,'Marker','o')
figure; hist(normVal,20);
line('Parent',gca,'XData',mean(normVal),'YData',0,'Marker','o')

% Make cumulative histogram
figure; cdfplot(indVal);
line('Parent',gca,'XData',mean(indVal),'YData',0,'Marker','o')
figure; cdfplot(normVal);
line('Parent',gca,'XData',mean(indVal),'YData',0,'Marker','o')