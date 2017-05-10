function varargout = mcViewer(varargin)
% MCVIEWER M-file for mcViewer.fig
%      MCVIEWER, by itself, creates a new MCVIEWER or raises the existing
%      singleton*.
%
%      H = MCVIEWER returns the handle to a new MCVIEWER or the handle to
%      the existing singleton*.
%
%      MCVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCVIEWER.M with the given input arguments.
%
%      MCVIEWER('Property','Value',...) creates a new MCVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before mcViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mcViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mcViewer

% Last Modified by GUIDE v2.5 22-Aug-2014 11:41:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mcViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @mcViewer_OutputFcn, ...
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


% --- Executes just before mcViewer is made visible.
function mcViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mcViewer (see VARARGIN)

% Choose default command line output for mcViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mcViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mcViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function filePath_Callback(hObject, eventdata, handles)
% hObject    handle to filePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filePath as text
%        str2double(get(hObject,'String')) returns contents of filePath as a double


% --- Executes during object creation, after setting all properties.
function filePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fileName_Callback(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileName as text
%        str2double(get(hObject,'String')) returns contents of fileName as a double


% --- Executes during object creation, after setting all properties.
function fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fileBaseName_Callback(hObject, eventdata, handles)
% hObject    handle to fileBaseName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileBaseName as text
%        str2double(get(hObject,'String')) returns contents of fileBaseName as a double
    genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function fileBaseName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileBaseName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fileCounter_Callback(hObject, eventdata, handles)
% hObject    handle to fileCounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileCounter as text
%        str2double(get(hObject,'String')) returns contents of fileCounter
%        as a double
    genericCallback(hObject);
    mcFlipTimeSeries;
    
    

% --- Executes during object creation, after setting all properties.
function fileCounter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileCounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function fileCounterSlider_Callback(hObject, eventdata, handles)
% hObject    handle to fileCounterSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider
    set(hObject, 'Value', round(get(hObject, 'Value')));
    genericCallback(hObject);
    mcFlipTimeSeries;


% --- Executes during object creation, after setting all properties.
function fileCounterSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileCounterSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in lowPass.
function lowPass_Callback(hObject, eventdata, handles)
% hObject    handle to lowPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lowPass
    global state
    genericCallback(hObject);
    if get(hObject, 'Value')
        mcFilterData(1:state.mcViewer.tsNumberOfFiles, 1, 1:state.mcViewer.nChannels);
    end


% --- Executes on button press in highPass.
function highPass_Callback(hObject, eventdata, handles)
% hObject    handle to highPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of highPass
    global state
    genericCallback(hObject);
    if get(hObject, 'Value')
        mcFilterData(1:state.mcViewer.tsNumberOfFiles, 1, 1:state.mcViewer.nChannels);
    end


function lowCutoff_Callback(hObject, eventdata, handles)
% hObject    handle to lowCutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowCutoff as text
%        str2double(get(hObject,'String')) returns contents of lowCutoff as
%        a double
    global state
    genericCallback(hObject);
    if state.mcViewer.lowPass
        mcFilterData(1:state.mcViewer.tsNumberOfFiles, 1, 1:state.mcViewer.nChannels);
    end

% --- Executes during object creation, after setting all properties.
function lowCutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowCutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function highCutoff_Callback(hObject, eventdata, handles)
% hObject    handle to highCutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of highCutoff as text
%        str2double(get(hObject,'String')) returns contents of highCutoff
%        as a double
    global state
    genericCallback(hObject);
    if state.mcViewer.highPass
        mcFilterData(1:state.mcViewer.tsNumberOfFiles, 1, 1:state.mcViewer.nChannels);
    end

% --- Executes during object creation, after setting all properties.
function highCutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to highCutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sampleRate_Callback(hObject, eventdata, handles)
% hObject    handle to sampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampleRate as text
%        str2double(get(hObject,'String')) returns contents of sampleRate as a double
    genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function sampleRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startX_Callback(hObject, eventdata, handles)
% hObject    handle to startX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startX as text
%        str2double(get(hObject,'String')) returns contents of startX as a double
    genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function startX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in displayFiltered.
function displayFiltered_Callback(hObject, eventdata, handles)
% hObject    handle to displayFiltered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displayFiltered
    global state
    genericCallback(hObject);
%     if ~state.mcViewer.displayFiltered
%         state.mcViewer.showThresh = 0;
%         updateGUIByGlobal(state.mcViewer.showThresh);
%     end
    for i = 1:state.mcViewer.nChannels
        if get(hObject, 'Value')
            state.mcViewer.channel(i).ShowFilter = 1;
        else
            state.mcViewer.channel(i).ShowFilter = 0;
        end
    end
    updateCurrentChannelGUIs(state.mcViewer.currentChannel); %ensure that GUIs are updated for current Channel    
    mcFlipTimeSeries;


% --- Executes on button press in showThresh.
function showThresh_Callback(hObject, eventdata, handles)
% hObject    handle to showThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showThresh
    global state
    genericCallback(hObject);
%     if state.mcViewer.showThresh
%         state.mcViewer.displayFiltered = 1;
%         updateGUIByGlobal(state.mcViewer.displayFiltered);
%     end
   mcFindPeaks;
   mcFlipTimeSeries;


% --- Executes on button press in blankTrain.
function blankTrain_Callback(hObject, eventdata, handles)
% hObject    handle to blankTrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of blankTrain
    global state
    genericCallback(hObject);



function pulseDelay_Callback(hObject, eventdata, handles)
% hObject    handle to pulseDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pulseDelay as text
%        str2double(get(hObject,'String')) returns contents of pulseDelay as a double
    global state
    genericCallback(hObject);

% --- Executes during object creation, after setting all properties.
function pulseDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulseDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nPulses_Callback(hObject, eventdata, handles)
% hObject    handle to nPulses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nPulses as text
%        str2double(get(hObject,'String')) returns contents of nPulses as a double
    global state
    genericCallback(hObject);

% --- Executes during object creation, after setting all properties.
function nPulses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nPulses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pulseISI_Callback(hObject, eventdata, handles)
% hObject    handle to pulseISI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pulseISI as text
%        str2double(get(hObject,'String')) returns contents of pulseISI as a double
    global state
    genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function pulseISI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulseISI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pulseWidth_Callback(hObject, eventdata, handles)
% hObject    handle to pulseWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pulseWidth as text
%        str2double(get(hObject,'String')) returns contents of pulseWidth as a double
    global state
    genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function pulseWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulseWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showSpikes.
function showSpikes_Callback(hObject, eventdata, handles)
% hObject    handle to showSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showSpikes
    global state
    genericCallback(hObject);
    mcUpdateSpikeLines;



function restrictChannelsToTrode_Callback(hObject, eventdata, handles)
% hObject    handle to restrictChannelsToTrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of restrictChannelsToTrode as text
%        str2double(get(hObject,'String')) returns contents of
%        restrictChannelsToTrode as a double
    genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function restrictChannelsToTrode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to restrictChannelsToTrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ssb_cluster_Callback(hObject, eventdata, handles)
% hObject    handle to ssb_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ssb_cluster as text
%        str2double(get(hObject,'String')) returns contents of ssb_cluster as a double
    global state

    value = str2double(get(hObject, 'String'));
    if value > length(state.mcViewer.trode(state.mcViewer.ssb_trode).cluster);
        value = length(state.mcViewer.trode(state.mcViewer.ssb_trode).cluster);
    end
    clusterValue = state.mcViewer.trode(state.mcViewer.ssb_trode).cluster(value).cluster;
    clusterCat = state.mcViewer.trode(state.mcViewer.ssb_trode).cluster(value).label;    
    state.mcViewer.ssb_cluster = value;
    updateGUIByGlobal('state.mcViewer.ssb_cluster');
    state.mcViewer.ssb_clusterValue = clusterValue;
    updateGUIByGlobal('state.mcViewer.ssb_clusterValue');
    state.mcViewer.ssb_clusterCat = clusterCat;
    updateGUIByGlobal('state.mcViewer.ssb_clusterCat')    
    mcUpdateSpikeSortBrowser;


% --- Executes during object creation, after setting all properties.
function ssb_cluster_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ssb_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ssb_trode_Callback(hObject, eventdata, handles)
% hObject    handle to ssb_trode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ssb_trode as text
%        str2double(get(hObject,'String')) returns contents of ssb_trode as a double
    global state
    value = str2double(get(hObject,'String'));    
    if value > length(state.mcViewer.trode)
        value = length(state.mcViewer.trode);
    end
    state.mcViewer.ssb_trode = value;   
    state.mcViewer.ssb_cluster = 1; % default to cluster #1 upon switching trode
    state.mcViewer.ssb_clusterValue = state.mcViewer.trode(value).cluster(1).cluster;
    state.mcViewer.ssb_clusterCat = state.mcViewer.trode(value).cluster(1).label;
    
    updateGUIByGlobal('state.mcViewer.ssb_trode');
    updateGUIByGlobal('state.mcViewer.ssb_cluster');
    updateGUIByGlobal('state.mcViewer.ssb_clusterValue');
    updateGUIByGlobal('state.mcViewer.ssb_clusterCat');
    mcUpdateSpikeSortBrowser;


% --- Executes during object creation, after setting all properties.
function ssb_trode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ssb_trode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ssb_clusterSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ssb_clusterSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global state
    value = get(hObject, 'Value');
    if value > length(state.mcViewer.trode(state.mcViewer.ssb_trode).cluster);
        value = length(state.mcViewer.trode(state.mcViewer.ssb_trode).cluster);
    end
    clusterValue = state.mcViewer.trode(state.mcViewer.ssb_trode).cluster(value).cluster;
    clusterCat = state.mcViewer.trode(state.mcViewer.ssb_trode).cluster(value).label;    
    state.mcViewer.ssb_cluster = value;
    updateGUIByGlobal('state.mcViewer.ssb_cluster');
    state.mcViewer.ssb_clusterValue = clusterValue;
    updateGUIByGlobal('state.mcViewer.ssb_clusterValue');
    state.mcViewer.ssb_clusterCat = clusterCat;
    updateGUIByGlobal('state.mcViewer.ssb_clusterCat');    
    mcUpdateSpikeSortBrowser;

% --- Executes during object creation, after setting all properties.
function ssb_clusterSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ssb_clusterSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function ssb_trodeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ssb_trodeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global state
    value = get(hObject, 'Value');
    if value > length(state.mcViewer.trode)
        value = length(state.mcViewer.trode);
    end
    state.mcViewer.ssb_trode = value;
        
    state.mcViewer.ssb_cluster = 1; % default to cluster #1 upon switching trode
    state.mcViewer.ssb_clusterValue = state.mcViewer.trode(value).cluster(1).cluster;
    state.mcViewer.ssb_clusterCat = state.mcViewer.trode(value).cluster(1).label;
    
    updateGUIByGlobal('state.mcViewer.ssb_trode');
    updateGUIByGlobal('state.mcViewer.ssb_cluster');
    updateGUIByGlobal('state.mcViewer.ssb_clusterValue');
    updateGUIByGlobal('state.mcViewer.ssb_clusterCat');
    mcUpdateSpikeSortBrowser;


% --- Executes during object creation, after setting all properties.
function ssb_trodeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ssb_trodeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when entered data in editable cell(s) in ssb_cycleTable.
function ssb_cycleTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to ssb_cycleTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% table should contain a rectangular matrix originating at (0,0) where each row contains
% a set of cycle positions to group together in a graph and the number of
% rows corresponds to the number of graphs
    global state
    table = get(hObject, 'Data');
    validEntries = find(table);
    size1 = max(find(table(:,1)));
    size2 = max(find(table(1,:)));
    state.mcViewer.ssb_cycleTable =  table(1:size1, 1:size2);
    mcUpdateCyclesByTable;



% --- Executes during object creation, after setting all properties.
function ssb_cycleTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ssb_cycleTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    global state
    data = zeros(16,8); % data property will always be this size
    set(hObject, 'Data', data);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over fileCounterSlider.
function fileCounterSlider_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to fileCounterSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global state
%     set(hObject, 'Max', state.mcViewer.tsNumberOfFiles);
%     set(hObject, 'SliderStep', [1/(state.mcViewer.tsNumberOfFiles - 1) 1/(state.mcViewer.tsNumberOfFiles - 1)*5]);


% --- Executes on button press in loadDaq.
function loadDaq_Callback(hObject, eventdata, handles)
% hObject    handle to loadDaq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global state
    state.mcViewer.displayThreshData = [];
    state.mcViewer.displayXData = [];
    if ~mcLoadDaq([], [], 1); % reload
        return
    end
    state.mcViewer.trode = [];
    if ishandle(state.mcViewer.spikeSortBrowser)
        close(state.mcViewer.spikeSortBrowser);
    end
    mcFilterData(1:state.mcViewer.tsNumberOfFiles, 1, 1:state.mcViewer.totalChannels);


% --- Executes on button press in spikeSortAll.
function spikeSortAll_Callback(hObject, eventdata, handles)
% hObject    handle to spikeSortAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mcSpikeSortAll;


% --- Executes on button press in saveSpikes.
function saveSpikes_Callback(hObject, eventdata, handles)
% hObject    handle to saveSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mcSaveSpikes;


% --- Executes on button press in mcLoadSpikes.
function mcLoadSpikes_Callback(hObject, eventdata, handles)
% hObject    handle to mcLoadSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mcLoadSpikes;


% --- Executes on button press in makeSpikeSortBrowser.
function makeSpikeSortBrowser_Callback(hObject, eventdata, handles)
% hObject    handle to makeSpikeSortBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mcMakeSpikeSortBrowser;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mcDeleteSpikeSortBrowser;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mcMakeMUAHist;


% --- Executes on selection change in probePopUp.
function probePopUp_Callback(hObject, eventdata, handles)
% hObject    handle to probePopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns probePopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from probePopUp
    global state
    val = get(hObject, 'Value');
    contents = get(hObject, 'String');
    state.mcViewer.channelOrder = state.mcViewer.probes{val, 2};
    state.mcViewer.probeIndex = val;
    state.mcViewer.probeName = contents{val};

% --- Executes during object creation, after setting all properties.
function probePopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to probePopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    set(hObject, 'String', {'Probe'}); %first column contains probe names
    set(hObject, 'Value', 1); % first menu item as default
    %channelOrder already defined as default within mcInit
    



function currentChannel_Callback(hObject, eventdata, handles)
% hObject    handle to currentChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentChannel as text
%        str2double(get(hObject,'String')) returns contents of currentChannel as a double
    global state
    val = str2num(get(hObject, 'String'));
    if val > state.mcViewer.totalChannels
        val = state.mcViewer.totalChannels;
    end
    fields = fieldnames(state.mcViewer.channel);
    state.mcViewer.currentChannel = val;
    updateGUIByGlobal('state.mcViewer.currentChannel');
    for i = 1:length(fields)
        field = fields{i};
        state.mcViewer.(['currentChannel' field]) = state.mcViewer.channel(val).(field);
        updateGUIByGlobal(['state.mcViewer.currentChannel' field]);
    end

function updateCurrentChannelGUIs(currentChannel) % utility function to update all currentChannel GUIs based upon currentChannel
    global state
    state.mcViewer.currentChannel = currentChannel;
    updateGUIByGlobal('state.mcViewer.currentChannel');
    fields = fieldnames(state.mcViewer.channel);    
    for i = 1:length(fields)
        field = fields{i};
        state.mcViewer.(['currentChannel' field]) = state.mcViewer.channel(currentChannel).(field);
        updateGUIByGlobal(['state.mcViewer.currentChannel' field]);
    end
        
% --- Executes during object creation, after setting all properties.
function currentChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function currentChannelSlider_Callback(hObject, eventdata, handles)
% hObject    handle to currentChannelSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global state
    if isempty(state.mcViewer.tsData)
        return
    end
    val = get(hObject, 'Value');
    mcFlipCurrentChannel(val);
%     if val > state.mcViewer.totalChannels
%         val = state.mcViewer.totalChannels;
%     end
%     state.mcViewer.currentChannel = val;    
%     fields = fieldnames(state.mcViewer.channel);
%     updateGUIByGlobal('state.mcViewer.currentChannel');
%     for i = 1:length(fields)
%         field = fields{i};
%         state.mcViewer.(['currentChannel' field]) = state.mcViewer.channel(val).(field);
%         updateGUIByGlobal(['state.mcViewer.currentChannel' field]);
%     end

        
% --- Executes during object creation, after setting all properties.
function currentChannelSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentChannelSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function currentChannelName_Callback(hObject, eventdata, handles)
% hObject    handle to currentChannelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentChannelName as text
%        str2double(get(hObject,'String')) returns contents of currentChannelName as a double
    genericCallback(hObject);
    updateChannelStruct;

% --- Executes during object creation, after setting all properties.
function currentChannelName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentChannelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in currentChannelmcFigureInclude.
function currentChannelmcFigureInclude_Callback(hObject, eventdata, handles)
% hObject    handle to currentChannelmcFigureInclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of currentChannelmcFigureInclude
    genericCallback(hObject);
    updateChannelStruct;
    

% --- Executes on button press in currentChannelauxFigureInclude.
function currentChannelauxFigureInclude_Callback(hObject, eventdata, handles)
% hObject    handle to currentChannelauxFigureInclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of currentChannelauxFigureInclude
    genericCallback(hObject);
    updateChannelStruct;

% --- Executes on button press in currentChannelShowFilter.
function currentChannelShowFilter_Callback(hObject, eventdata, handles)
% hObject    handle to currentChannelShowFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of currentChannelShowFilter
    global state
    genericCallback(hObject);
    updateChannelStruct;
    mcFlipTimeSeries;


function currentChannelLowPass_Callback(hObject, eventdata, handles)
% hObject    handle to currentChannelLowPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentChannelLowPass as text
%        str2double(get(hObject,'String')) returns contents of currentChannelLowPass as a double
    genericCallback(hObject);
    updateChannelStruct;

% --- Executes during object creation, after setting all properties.
function currentChannelLowPass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentChannelLowPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function currentChannelHighPass_Callback(hObject, eventdata, handles)
% hObject    handle to currentChannelHighPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentChannelHighPass as text
%        str2double(get(hObject,'String')) returns contents of currentChannelHighPass as a double
    genericCallback(hObject);
    updateChannelStruct;

% --- Executes during object creation, after setting all properties.
function currentChannelHighPass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentChannelHighPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function updateChannelStruct
    global state
    fields = fieldnames(state.mcViewer.channel);
    for i = 1:length(fields)
        field = fields{i};
        state.mcViewer.channel(state.mcViewer.currentChannel).(field) = ...
            state.mcViewer.(['currentChannel' field]);
    end


% --- Executes on button press in updateFigures.
function updateFigures_Callback(hObject, eventdata, handles)
% hObject    handle to updateFigures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global state
    mcMakeChannelPlots;    
    filterChannels=find(find(mcChannelFieldToVector('ShowFilter')) > state.mcViewer.nChannels); %only filter aux channels with filtering on...
    mcFilterData(1:state.mcViewer.tsNumberOfFiles, 1, filterChannels);    


% --- Executes on button press in sg_on.
function sg_on_Callback(hObject, eventdata, handles)
% hObject    handle to sg_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sg_on
    global state
    genericCallback(hObject);
    if get(hObject, 'Value')
        set(state.mcViewer.sg_figure, 'Visible', 'On');
        state.mcViewer.sg_on = 1;
        mcUpdateSgFigure;
    else
        set(state.mcViewer.sg_figure, 'Visible', 'Off');
        state.mcViewer.sg_on = 0;
    end
    


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
%     eventdata
%     disp('from figure');


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    global state
    switch eventdata.Key
        case 'uparrow'
            mcFlipCurrentChannel(state.mcViewer.currentChannel + 1);
        case 'downarrow'
            mcFlipCurrentChannel(max(state.mcViewer.currentChannel -1, 1));
        otherwise
    end



function bl1_Callback(hObject, eventdata, handles)
% hObject    handle to bl1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bl1 as text
%        str2double(get(hObject,'String')) returns contents of bl1 as a double
    genericCallback(hObject);

% --- Executes during object creation, after setting all properties.
function bl1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bl1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bl2_Callback(hObject, eventdata, handles)
% hObject    handle to bl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bl2 as text
%        str2double(get(hObject,'String')) returns contents of bl2 as a double
    genericCallback(hObject);

% --- Executes during object creation, after setting all properties.
function bl2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double
    genericCallback(hObject);

% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_Callback(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2 as text
%        str2double(get(hObject,'String')) returns contents of x2 as a double
    genericCallback(hObject);

% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to ssb_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ssb_cluster as text
%        str2double(get(hObject,'String')) returns contents of ssb_cluster as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ssb_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to ssb_trode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ssb_trode as text
%        str2double(get(hObject,'String')) returns contents of ssb_trode as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ssb_trode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function decimate_Callback(hObject, eventdata, handles)
% hObject    handle to decimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of decimate as text
%        str2double(get(hObject,'String')) returns contents of decimate as a double
    genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function decimate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rejectAcq.
function rejectAcq_Callback(hObject, eventdata, handles)
% hObject    handle to rejectAcq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rejectAcq
    global state
    genericCallback(hObject);
    state.mcViewer.tsRejectAcq(1, state.mcViewer.fileCounter) = state.mcViewer.rejectAcq;
    


% --- Executes on button press in showSelected.
function showSelected_Callback(hObject, eventdata, handles)
% hObject    handle to showSelected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showSelected
    genericCallback(hObject);


% --- Executes on button press in loadLight.
function loadLight_Callback(hObject, eventdata, handles)
% hObject    handle to loadLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mcLoadSpikes(1); % light mode


% --- Executes on button press in backupButton.
function backupButton_Callback(hObject, eventdata, handles)
% hObject    handle to backupButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
    mcSaveSpikes(1);
% handles    structure with handles and user data (see GUIDATA)
