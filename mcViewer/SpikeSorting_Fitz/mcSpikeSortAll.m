function mcSpikeSortAll
    global state
    state.mcViewer.trode = [];
    mcSpikeSort(1:4, 'trode1');
    drawnow; pause(.1)
    mcSpikeSort(5:8, 'trode2');
    drawnow; pause(.1)
    mcSpikeSort(9:12, 'trode3');
    drawnow; pause(.1)
    mcSpikeSort(13:16, 'trode4');
    drawnow; pause(.1)