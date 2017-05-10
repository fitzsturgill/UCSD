function mcFilterAll
disp('mcFilterAll deprecated');
%     global state
%     if ~state.mcViewer.tsNumberOfFiles
%         return
%     end
%     h = waitbar(0, 'Filtering Data');
%     for i = 1:state.mcViewer.tsNumberOfFiles
%         mcFilterData(i, 1);
%         mcFlipTimeSeries(i);
%         waitbar(i/state.mcViewer.tsNumberOfFiles);
%     end
%     close(h);