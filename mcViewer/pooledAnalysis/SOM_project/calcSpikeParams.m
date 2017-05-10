    function calcSpikeParams

        global clusters
        
        % start and stop of baseline period in ms
        bl1=-0.5;
        bl2=-0.3;

        for i = 1:length(clusters)
            if isfield(clusters(i).analysis, 'WaveForm') && isfield(clusters(i).analysis.WaveForm, 'spikeAvg')
                spikeAvg=clusters(i).analysis.WaveForm.spikeAvg;
                spikeAvgX=clusters(i).analysis.WaveForm.spikeAvgX;
                startX=spikeAvgX(1);
                endX = spikeAvgX(end);
                deltaX = spikeAvgX(2) - spikeAvgX(1);

                
                auxBaseline=1; % detect weird baselining events and attempt to rectify
                while 1
                    bl = mean(spikeAvg(x2point(bl1, startX, deltaX, endX):x2point(bl2, startX, deltaX, endX)));
                    spikeAvgBl=spikeAvg - bl; % baseline                    
                    % Find trough amplitude
                    [trough t_loc] = min(spikeAvgBl);
                    trough = -trough;

                    % Find peak amplitude
                    [peak p_loc] = max(spikeAvgBl(t_loc:end));
                    p_loc = p_loc + t_loc - 1;

                    % Compute trough:peak amplitude
                    tp = peak/trough;

                    % Compute time from trough to peak
                    tp_time = spikeAvgX(p_loc) - spikeAvgX(t_loc);

                    % compute width, i.e width at 1/2 max
                    % first normalize spikeAvg
                    spikeAvgNorm = spikeAvgBl / trough;
                    if auxBaseline && abs(spikeAvgNorm(1)) > 0.2
                        bl1=-1;
                        bl2=-0.6;
                        auxBaseline=0;
                    else
                        break
                    end
                end
                    % Find -0.5 crossings
                [ind, halfX] = crossing(spikeAvgNorm, spikeAvgX, -0.5);
                
                if length(ind) ~= 2
                    disp('error in calcSpikeParams, add error checking');
                end
                
                % compute width
                width = halfX(2) - halfX(1);
                
                % update output
                clusters(i).analysis.WaveForm.width=width;
                clusters(i).analysis.WaveForm.spikeAvgNorm=spikeAvgNorm;
                clusters(i).analysis.WaveForm.tp_time=tp_time;
                clusters(i).analysis.WaveForm.tp_ratio=tp;   
            end
        end

    
    
    function p=x2point(x, startX, deltaX, endX)  % local version
        p=min(max(round(1+(x-startX)/deltaX), 1), length(startX:deltaX:endX));