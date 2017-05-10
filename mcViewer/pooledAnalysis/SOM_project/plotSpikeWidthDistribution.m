function plotSpikeWidthDistribution(indices)
% this is a throw away function
    global clusters
widths = zeros(1, length(indices));
for i = 1:length(indices)
    widths(1, i) = clusters(indices(i)).analysis.WaveForm.data.spikeWidth;
end
figure('Name', 'Spike Width Distribution', 'NumberTitle', 'off');
hist(widths, 20);
title('Spike Width Distribution');
xlabel('Spike Widths (ms)');
ylabel('# neurons');