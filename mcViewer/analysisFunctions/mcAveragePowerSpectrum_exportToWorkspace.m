function waveList=mcAveragePowerSpectrum_exportWaves(varargin)
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
        cycles = state.mcViewer.ssb_cycleTable;
        cycles = reshape(cycles, 1, numel(cycles));
        channel = state.mcViewer.sg_channel;
        
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
                case 'channel'
                    channel=val;
                otherwise
            end
            counter=counter+2;
        end



        % generate wave and/or figure prefix
        prefix = mcExpPrefix;   
        prefix = 'shea'
        

        TW = state.mcViewer.sg_TW;
        p = state.mcViewer.sg_p;
        params = struct(...
            'tapers', [TW 2*TW - (1 + p)],... % see chronux manual for rationale
            'Fs', state.mcViewer.sampleRate * 1000,...
            'fpass', [0 80],...
            'trialave', 1, ...
            'err', [1 .05]...  % 95% confidence interval
            );


        waveList = {};
        for i = 1:length(cycles)
            for j = 1:2 % testPeriod and baselinePeriod
                if j == 2
                    startTime = mcX2pnt(x1);
                    stopTime = mcX2pnt(x2);
                else
                    startTime = mcX2pnt(bl1);
                    stopTime = mcX2pnt(bl2);
                end            
                cycle = cycles(i);
                trials  = mcTrialsByCycle(cycle);
                data =  cat(3, state.mcViewer.tsData{1, trials}); %memory intensive way of doing this
                data = squeeze(data(:, channel, :)); % memory intensive way of doing this
                data = diff(data); % prewhitening

                % calc power spectra 
                [S, f, Serr] = mtspectrumc(data(startTime:stopTime), params);
                % row vectors
                S = S';
                f = f;
                SerrLow = Serr(1,:);
                SerrHigh = Serr(2,:);
                
                %make waves
                baseName = [prefix 'c' num2str(cycle) 'e' num2str(j) 'PS'];
                xName = baseName;
%                 yName = [baseName 'f']
                lowName = [baseName '_semlow']; % hacking graphSEMBounds function from IGOR, suffixes have to match
                highName = [baseName '_semhi'];
                xscale = [f(1) f(2) - f(1)];
                waveo(xName, S, 'xscale', xscale);
%                 evalin('base', [xname '=S;']);
                waveo(lowName, SerrLow, 'xscale', xscale);
                waveo(highName, SerrHigh, 'xscale', xscale);
                waveList = [waveList {xName, lowName, highName}];
            end
        end
%         return
%         mkdir(state.mcViewer.filePath,'analysis'); % make directory if it doesn't already exist
        
%         exportWave(waveList, '', fullfile(state.mcViewer.filePath,'analysis', [mcExpPrefix 'avg_PwSpec']));
%         disp(['***Saving: ' fullfile(state.mcViewer.filePath,'analysis', [mcExpPrefix 'avg_PwSpec']) '***']);

        
        
        
