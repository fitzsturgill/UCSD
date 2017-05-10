function ax=mcShowAnalysis_SpikeLFPCoherence(trode, clust, varargin)
        global state
        
        if ~isfield(state.mcViewer.trode(trode).cluster(clust).analysis, 'SpikeLFPCoherence')
            ax=[];
            return
        end
        %defaults or null values for paramters
        h = []; %if default, generate a fresh figure
        cycles = state.mcViewer.ssb_cycleTable; % default, determines arrangement of axes on each cluster's figure (cycles that share a row are graphed together, each row generates a separate axes)
        collapse=0;
        % parse input parameter pairs
        counter = 1;
        while counter+1 <= length(varargin) 
            prop = varargin{counter};
            val = varargin{counter+1};
            switch prop
                case 'h'
                    h = val;
                case 'cycles'
                    cycles = val;
                case 'collapse'
                    collapse = val;
                otherwise
                    error('mcProcessAnalysis_SpikeLFPAverage : Invalid Parameter')
            end
            counter=counter+2;
        end
        
        % generate wave and/or figure prefix
        prefix = mcExpPrefix;
        
        % deal with parameter contingencies
        if isempty(h)
            h = figure(...
                'Name', [prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg']...
                );
            newFig = 1;
        else
            figure(h); % bring figure to front and make current figure
            newFig = 0;
        end
        
        lineColor = state.mcViewer.lineColor;
        for i = 1:size(cycles, 1);     
            ax(i) = axes;
            title(['Cyc: ' num2str(cycles(i,:))], 'FontSize', 7);
            for j = 1:size(cycles, 2); % why do I even have a loop here???
                x1=cat(1, state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.f{cycles(i, :),1});
                x2=cat(1, state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.f{cycles(i, :),2});
                y1=cat(1, state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.C{cycles(i, :),1});
                y2=cat(1, state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.C{cycles(i, :),2});
                b1=cat(3, state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.Cerr2{cycles(i, :),1});
                b2=cat(3, state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.Cerr2{cycles(i, :),2});
                boundedline(x1', y1', b1, '-', x2', y2', b2, ':', 'alpha', ax(i), 'cmap', vertcat(lineColor{1, 1:size(cycles,2)}), 'transparency', .1);
%                 boundedline(x1', y1', b1, '-', x2', y2', b2, ':', 'alpha', ax(i), 'cmap', vertcat(lineColor{1, 1:size(cycles,1)}), 'transparency', .1);  % FS MOD 4/22/2013, trying to figure out coloring, etc.
            end
        end
        
        if newFig
            ax=textAxes(h, [prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg'], 8);
            splayAxisTile;
        end
        
        % stuff for 1 cycle only generation of waves for a figure....
        % update this later....
%             waveo([prefix 'Coh_bl'], y1, 'xscale', [x1(1) x1(2)-x1(1)]);
%             waveo([prefix 'Coh_bl_semlow'], state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.Cerr{1,1}(:,1), 'xscale', [x1(1) x1(2)-x1(1)]);            
%             waveo([prefix 'Coh_bl_semhi'], state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.Cerr{1,1}(:,2), 'xscale', [x1(1) x1(2)-x1(1)]);                        
%             waveo([prefix 'Coh_od'], y2, 'xscale', [x2(1) x2(2)-x2(1)]);
%             waveo([prefix 'Coh_od_semlow'], state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.Cerr{1,2}(:,1), 'xscale', [x2(1) x2(2)-x2(1)]);            
%             waveo([prefix 'Coh_od_semhi'], state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPCoherence.data.Cerr{1,2}(:,2), 'xscale', [x2(1) x2(2)-x2(1)]);
%             waveList = {...
%                 [prefix 'Coh_bl']...
%                 [prefix 'Coh_bl_semlow']...
%                 [prefix 'Coh_bl_semhi']...
%                 [prefix 'Coh_od']...
%                 [prefix 'Coh_od_semlow']...
%                 [prefix 'Coh_od_semhi']...
%                 };
%             exportWave(waveList);
            % end 1 cycle only wave code