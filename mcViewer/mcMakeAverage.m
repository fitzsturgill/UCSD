function avgnames = mcMakeAverage(fileNumbers)
    global state
    
    
    for j = 1:size(fileNumbers, 1)
        fileNumber = fileNumbers(j);
        for i = 1:state.mcViewer.nChannels
            avgname = ['bulb_365_p' num2str(fileNumber) '_ch' num2str(i) '_avg'];
            avgnames{i,j} = avgname;
            waveo(['temp_ch' num2str(i)], state.mcViewer.tsFilteredData{1, fileNumber}(:, i));
            if ~iswave(avgname)
                waveo(avgname, []); %make wave object 
            end
            avgin(['temp_ch' num2str(i)], avgname);         
        end
    end
