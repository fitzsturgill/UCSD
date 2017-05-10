function varargout = mcFeatures(varargin)
% MCFEATURES M-file for mcFeatures.fig
%      MCFEATURES, by itself, creates a new MCFEATURES or raises the existing
%      singleton*.
%
%      H = MCFEATURES returns the handle to a new MCFEATURES or the handle to
%      the existing singleton*.
%
%      MCFEATURES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCFEATURES.M with the given input arguments.
%
%      MCFEATURES('Property','Value',...) creates a new MCFEATURES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mcFeatures_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mcFeatures_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mcFeatures

% Last Modified by GUIDE v2.5 07-Feb-2013 15:47:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mcFeatures_OpeningFcn, ...
                   'gui_OutputFcn',  @mcFeatures_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mcFeatures is made visible.
function mcFeatures_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mcFeatures (see VARARGIN)

% Choose default command line output for mcFeatures
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mcFeatures wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mcFeatures_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function respirationChannel_Callback(hObject, eventdata, handles)
% hObject    handle to respirationChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of respirationChannel as text
%        str2double(get(hObject,'String')) returns contents of respirationChannel as a double
    genericCallback(hObject);
    state.mcViewer.features.respiration = []; %reset respiration


% --- Executes during object creation, after setting all properties.
function respirationChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to respirationChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showRespiration.
function showRespiration_Callback(hObject, eventdata, handles)
% hObject    handle to showRespiration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showRespiration
    global state
    genericCallback(hObject);
    if get(hObject, 'Value') && (~isfield(state.mcViewer.features, 'respiration') || isempty(state.mcViewer.features.respiration))
%         mcFindRespTimes(state.mcViewer.respirationChannel, [], state.mcViewer.respirationDirection);
        mcFindRespTimes(state.mcViewer.respirationChannel, 1:state.mcViewer.tsNumberOfFiles);
    end
%     mcUpdateRespirationLines;


% --- Executes on button press in respirationDirection.
function respirationDirection_Callback(hObject, eventdata, handles)
% hObject    handle to respirationDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of respirationDirection
    global state
    val = get(hObject, 'Value');
    if val == 1
        state.mcViewer.respirationDirection = 1;
    else
        state.mcViewer.respirationDirection = -1;
    end
    state.mcViewer.features.respiration = []; %reset respiration


% --- Executes during object creation, after setting all properties.
function respirationDirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to respirationDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in alignHist.
function alignHist_Callback(hObject, eventdata, handles)
% hObject    handle to alignHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of alignHist
    global state
    genericCallback(hObject);
    if get(hObject, 'Value') && isfield(state.mcViewer.features, 'respiration') && ~isempty(state.mcViewer.features.respiration) && isempty(state.mcViewer.trode(1).cluster(1).spikeTimesAligned{1,1})
        mcAlignClustersByRespiration(state.mcViewer.alignHistTime);
    end
    state.mcViewer.ssb_alignHist=get(hObject, 'Value'); % link to spikeSortBrowser
    mcUpdateSpikeSortBrowser;


function alignHistTime_Callback(hObject, eventdata, handles)
% hObject    handle to alignHistTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alignHistTime as text
%        str2double(get(hObject,'String')) returns contents of alignHistTime as a double
    global state
    genericCallback(hObject);
    if isfield(state.mcViewer.features, 'respiration') && ~isempty(state.mcViewer.features.respiration)
        mcAlignClustersByRespiration(state.mcViewer.alignHistTime);
    end

% --- Executes during object creation, after setting all properties.
function alignHistTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alignHistTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function respirationStringency_Callback(hObject, eventdata, handles)
% hObject    handle to respirationStringency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of respirationStringency as text
%        str2double(get(hObject,'String')) returns contents of respirationStringency as a double
    global state
    genericCallback(hObject);
    mcFindRespTimes([], 1:state.mcViewer.tsNumberOfFiles);

% --- Executes during object creation, after setting all properties.
function respirationStringency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to respirationStringency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function respirationStringencySlider_Callback(hObject, eventdata, handles)
% hObject    handle to respirationStringencySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global state
    genericCallback(hObject);
    mcFindRespTimes([], 1:state.mcViewer.tsNumberOfFiles);


% --- Executes during object creation, after setting all properties.
function respirationStringencySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to respirationStringencySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function respirationOffset_Callback(hObject, eventdata, handles)
% hObject    handle to respirationOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of respirationOffset as text
%        str2double(get(hObject,'String')) returns contents of respirationOffset as a double
    global state
    genericCallback(hObject);
    h = waitbar(0, 'Calculating Shifted Respiration');       
    for i = 1:state.mcViewer.tsNumberOfFiles
        [shiftedTimes shiftedIndices] = calcShiftedRespiration(state.mcViewer.features.respiration.times{1, i}, state.mcViewer.sampleRate, state.mcViewer.respirationOffset, state.mcViewer.tsXData{1, i});
        state.mcViewer.features.respiration.timesShifted{1, i} = shiftedTimes;
        state.mcViewer.features.respiration.indicesShifted{1, i} = shiftedIndices;
        waitbar(i/state.mcViewer.tsNumberOfFiles);               
    end
    mcFlipTimeSeries; % update respiration lines
    close(h);

% --- Executes during object creation, after setting all properties.
function respirationOffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to respirationOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function respirationOffsetSlider_Callback(hObject, eventdata, handles)
% hObject    handle to respirationOffsetSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function respirationOffsetSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to respirationOffsetSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





% --- Executes on button press in respirationLock.
function respirationLock_Callback(hObject, eventdata, handles)
% hObject    handle to respirationLock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of respirationLock
    global state
    genericCallback(hObject);
    try
        state.mcViewer.features.respiration.tsRespirationLock(1, state.mcViewer.fileCounter)=0;
    catch
        disp('respiration not yet analyzed');
    end


function acqStringency_Callback(hObject, eventdata, handles)
% hObject    handle to acqStringency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of acqStringency as text
%        str2double(get(hObject,'String')) returns contents of acqStringency as a double
    global state
    genericCallback(hObject);
    mcFindRespTimes([], [], 1, state.mcViewer.acqStringency); % just this acquisition


% --- Executes during object creation, after setting all properties.
function acqStringency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acqStringency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function acqStringencySlider_Callback(hObject, eventdata, handles)
% hObject    handle to acqStringencySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global state
    genericCallback(hObject);
    mcFindRespTimes([], [], 1, state.mcViewer.acqStringency); % just this acquisition

% --- Executes during object creation, after setting all properties.
function acqStringencySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acqStringencySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
