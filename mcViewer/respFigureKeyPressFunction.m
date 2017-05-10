function respFigureKeyPressFunction
	global state
	val = double(get(gcbo,'CurrentCharacter'));

	if ~isnumeric(val) || isempty(val);
		return
    end
    limits = get(state.mcViewer.respirationAxis, 'XLim');
    extent= limits(2) -  limits(1);
	try
		switch val
            case {109, 118} % m- advance to next acquisition
                state.mcViewer.fileCounter = min(state.mcViewer.fileCounter +1, state.mcViewer.tsNumberOfFiles);
                updateGUIByGlobal('state.mcViewer.fileCounter');
                mcFlipTimeSeries;                
            case {110, 99} % n- previous acquisition
                state.mcViewer.fileCounter = max(state.mcViewer.fileCounter - 1, 1);
                updateGUIByGlobal('state.mcViewer.fileCounter');
                mcFlipTimeSeries;             
            case 29 % right- shift x axes 200 to right
                set(state.mcViewer.respirationAxis, 'XLim', limits + extent);
            case 28 % left - shift left
                set(state.mcViewer.respirationAxis, 'XLim', limits - extent);
            case 30 % up
                set(state.mcViewer.respirationAxis, 'XLim', [limits(1) + extent/4 limits(2) - extent/4]);                
            case 31 % down
                set(state.mcViewer.respirationAxis, 'XLim', [limits(1) - extent/2 limits(2) + extent/2]);    
            case 97 % a- auto
                set(state.mcViewer.respirationAxis, 'XLimMode', 'auto');
            case 122 % z- add respiration point
                set(state.mcViewer.respirationFigure, 'Pointer', 'crosshair');              
            case 120 % x- delete respiration point
                set(state.mcViewer.respirationFigure, 'Pointer', 'cross');                                                                
		otherwise
		end
	catch
 		lasterr
    end
    

%             case 97 % a- (a)dd respiration point
%                 
%             case 115 % s- (s)hift respiration point
%                 
%             case 100 % d- (d)elete respiration point
                