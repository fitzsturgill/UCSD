function mcAcqInitializeOlfactometer

    global state
   

    state.phys.mcAcq.olfBoardIndex='Dev3'; % kludge
    state.phys.mcAcq.olfDevice = digitalio('nidaq', state.phys.mcAcq.olfBoardIndex);
    set(state.phys.mcAcq.olfDevice, 'TimerFcn', @mcAcqOlf_callback);

    state.phys.mcAcq.olfHwLines=[0:6]; % kludge
    state.phys.mcAcq.olfPort=0; % kludge
    state.phys.mcAcq.olfLines = addline(state.phys.mcAcq.olfDevice, state.phys.mcAcq.olfHwLines, state.phys.mcAcq.olfPort, 'out');
    if state.phys.mcAcq.olfShuntEnabled
        state.phys.mcAcq.olfShuntLine = addline(state.phys.mcAcq.olfDevice, state.phys.mcAcq.olfShuntHwLine, state.phys.mcAcq.olfPort, 'out');
    end
    state.phys.mcAcq.olfValveStatus = 0;  % initialize this so that valvce turns on with first acquisition
%     state.phys.mcAcq.olfValveCode = logical([...
%         1 0 0 0;... ch1
%         0 1 0 0;... ch2
%         1 1 0 0;... ch3
%         0 0 1 0;... ch4
%         1 0 1 0;... ch5
%         0 1 1 0;... ch6
%         1 1 1 0;... ch7
%         0 0 0 1;... ch8
%         1 0 0 1;... ch9
%         0 1 0 1;... ch10
%         1 1 0 1;... ch11
%         0 0 1 1;... ch12
%         1 0 1 1;... ch13
%         0 1 1 1;... ch14
%         1 1 1 1;... ch15
%         0 0 0 0;... none or 16 if auto memory mode is utilized        
%         ]);
    
    mcAcqValveSwitch(state.phys.mcAcq.olfDefaultValve); % turn dummy odor on