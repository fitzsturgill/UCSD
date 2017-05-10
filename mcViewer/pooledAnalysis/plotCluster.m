function plotCluster(indices, ax, norm, linespec, bounded)
    global clusters;
    
    if nargin < 5
        bounded = 0; % plot average with sem bounds
    end
    
    if nargin < 4
        linespec='-k';
    end
    
    if nargin < 3
        norm=1;
    end
    if nargin < 2
        ax=[];
    end
    
    if isempty(ax)
        fig = figure;
        ax = axes('Parent', fig);
        hold on;
    else
        axes(ax);
        hold on;
    end
    
    for i=1:length(indices)

        ind=indices(i);
        sx=clusters(ind).analysis.WaveForm.spikeAvgX;
        if norm
            s=clusters(ind).analysis.WaveForm.spikeAvgNorm;
        else
            s=clusters(ind).analysis.WaveForm.spikeAvg;
        end
        if bounded && i==1
            all = zeros(length(indices), length(sx)); % initialize
        end
        if ~bounded
            plot(ax, sx, s, linespec);
        else
            all(i,:) = s;
        end  
    end
    
    if bounded
        allAvg = mean(all);
        allSEM = std(all) ./ sqrt(size(all, 1));
        if bounded == 1
            boundedline(sx, allAvg, allSEM, linespec, ax);
        elseif bounded == 2
            boundedline(sx, allAvg, std(all), linespec, ax);     
        end
    end