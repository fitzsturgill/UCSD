function h = plotCumHist(data, fig, figName, linespec)
    % data should correspond to structure with fields, data and name
    % output is handle to axes as well as structure with new fields, index
    % and sorted
    
    if nargin < 4
        linespec = {'k', 'r', 'b', 'g', 'm', 'c', 'y'};
    end
    
    if nargin < 3
        figName = 'cumHist';
    end
    
    if nargin < 2  || isempty(fig)         
        fig = figure(...
            'Name', figName,...
            'NumberTitle', 'off'...     
            ); 
    end

    
    if ~all(isfield(data, {'data', 'name'}))
        disp('Error in plotCumHist, improper structure input, see doc, returning');
        return
    end
    
    
    
    for i = 1:length(data);
        [sorted index] = cum(data(i).data);
        data(i).sorted = sorted;
        data(i).index = index;
        plot(sorted, index, linespec{1, i});
         hold on;
    end
    
    h  = gca;
    set(h, 'TickDir', 'out');
end


function [sorted index]=cum(a)
    % for generation of cumulative probability plots
    
    if numel(a) ~= length(a)
        disp('error in cum: input argument not a row or column vector');
        return
    end
    
    sorted = sort(a);
    index = (0:numel(a) - 1) / (numel(a) - 1);
end
        
    
    