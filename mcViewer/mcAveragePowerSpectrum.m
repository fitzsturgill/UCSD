function ax = mcAveragePowerSpectrum(varargin)
%Todo: include error bars!!!!!
% Generates axes based on ssb_cycletable containning power spectra for
% baseline and ododr periods.
% Power Spectra are stored as waves and returned in waveList for possible
% saving or other uses.
% Note if passing a figure handle, it is possible that closing that figure
% handle will leave invalid handles in the waves 'plot' property if you
% don't have the proper closeRequestFunction for that figure- (pain in
% ass!)
%optional parameters (included as parameter, value pairs in varargin)
% x1- start odor, default state.mcViewer.x1 (same for other time props
% below)
% x2 - end odor
% bl1- start baseline
% bl2- end baseline
% h - handle of target figure, if empty, creates new figure, default- empty
% cycles (can be of 2 dimensions- rows include cycles shared within a axes
% columns cycles separated by axes, default- ssb_cycletable
% channel- chanel for power spectra, default- sg_channel
        global state
    
            %default values
        x1 = state.mcViewer.x1; 
        x2 = state.mcViewer.x2;
        bl1 = state.mcViewer.bl1;
        bl2 = state.mcViewer.bl2;       
        h = []; %if default, generate a fresh figure
        cycles = state.mcViewer.ssb_cycleTable;
        channel = state.mcViewer.sg_channel;
        collapse=0; % average cycles across columns
        
        % parse input parameter pairs
        counter = 1;
        while counter+1 <= length(varargin) 
            prop = varargin{counter};
            val = varargin{counter+1};
            switch prop
                case 'x1'
                    x1 = val;
                case 'x2'
                    x2 = val;
                case 'bl1'
                    bl1 = val;
                case 'bl2'
                    bl2 = val;                    
                case 'cycles'
                    cycles = val;
                case 'h'
                    h=val;
                case 'channel'
                    channel=val;
                case 'collapse' % average cycles across columns
                    collapse=val;
                otherwise
            end
            counter=counter+2;
        end



        % generate wave and/or figure prefix
        prefix = mcExpPrefix;
        lineColor = state.mcViewer.lineColor;        
        
        % deal with parameter contingencies
        if isempty(h)
            h = figure(...
                'Name', [prefix 'ch' num2str(channel) '_avgPowerSpectrum'],...
                'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
                  'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');            

        else
            figure(h); % bring figure to front and make current figure
        end

        TW = state.mcViewer.sg_TW;
        p = state.mcViewer.sg_p;
        params = struct(...
            'tapers', [TW 2*TW - (1 + p)],... % see chronux manual for rationale
            'Fs', state.mcViewer.sampleRate * 1000,...
            'fpass', [0 100],...
            'trialave', 1, ...
            'err', [1 .32]...  % 95% confidence interval
            );



        for i = 1:size(cycles, 1);     
            ax(i) = axes; %target figure is gcf
            xlabel('F (Hz)');
            ylabel('Power');
            if ~collapse
                graphLabel = ['Ch' num2str(channel) ' Cyc' num2str(cycles(i,:))];
            else
                graphLabel = ['Ch' num2str(channel) ' Cyc' num2str(cycles(i, :)) ' collapse'];
            end
            text(.1,.9,graphLabel,'Units','normalized');
            S1=[];
            f1=[];
            Serr1=[];
            S2=[];
            f2=[];
            Serr2=[];
            for j = 1:size(cycles, 2);
                % make colors nice for different graph styles (according to
                % ssb_cycleTable)
%                 if size(cycles, 1) > 2
%                     if j == 1
%                         thisColor = [.5 .5 .5]; % grey if multiple rows exist and you are in first column of ssb_cycleTable
%                     else
%                         thisColor = lineColor{1, i};
%                     end
%                 else
%                     thisColor = lineColor{1, j}; % there is only one row, don't have first column be grey, i.e. treat it the same as other cycle positiosn on cycletable
%                 end
                if ~collapse
                    cycle = cycles(i, j);
                else
                    cycle = cycles(:, j);
                end
                trials  = mcTrialsByCycle(cycle);
                data =  cat(3, state.mcViewer.tsData{1, trials}); %memory intensive way of doing this
                data = squeeze(data(:, channel, :)); % memory intensive way of doing this
                data = diff(data); % prewhitening

                % calc power spectra for baseline period
                [S, f, Serr] = mtspectrumc(data(mcX2pnt(bl1):mcX2pnt(bl2), :), params);
                % convert directly to column vectors as BoundedLine takes
                % column vectors as parameters
                f = f';
                Serr = Serr';
                Serr = abs(Serr - repmat(S, 1, 2)); % convert to error magnitudes rather than confidence interval boundaries

                S1 = [S1 S]; % add additional columns (or 3rd dimension) corresponding to additional bounded lines for cycles in a row in cycleTable
                f1 = [f1 f];
                Serr1 = cat(3, Serr1, Serr);
                
                % calc power spectra for odor period
                [S, f, Serr] = mtspectrumc(data(mcX2pnt(x1):mcX2pnt(x2), :), params);
  
                f = f';
                Serr = Serr';    
                Serr = abs(Serr - repmat(S, 1, 2)); % convert to error magnitudes rather than confidence interval boundaries
                
                S2 = [S2 S]; % add additional columns (or 3rd dimension) corresponding to additional bounded lines for cycles in a row in cycleTable
                f2 = [f2 f];
                Serr2 = cat(3, Serr2, Serr); 

            end
            boundedline(f1, S1, Serr1, ':', f2, S2, Serr2, '-', 'alpha', ax(i), 'cmap', vertcat(lineColor{1, 1:size(cycles,2)}), 'transparency', .1); 
            if collapse
                return % quit after 1 loop iteration if averaging over cycles, only 1 axes produced
            end
        end
        setSameYmax(ax);
        params.matpos = [0.02 0.02 .96 .96];
        params.cellmargin = [.05 .05 .05 .05];
        rows=2;
        columns=ceil(size(cycles, 1)/2); % ditto
        setaxesOnaxesmatrix_old(ax, rows, columns, 1:numel(ax), params, h);
        
