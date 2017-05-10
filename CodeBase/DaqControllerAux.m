function varargout = DaqControllerAux(varargin)
% DAQCONTROLLERAUX M-file for DaqControllerAux.fig
%      DAQCONTROLLERAUX, by itself, creates a new DAQCONTROLLERAUX or raises the existing
%      singleton*.
%
%      H = DAQCONTROLLERAUX returns the handle to a new DAQCONTROLLERAUX or the handle to
%      the existing singleton*.
%
%      DAQCONTROLLERAUX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAQCONTROLLERAUX.M with the given input arguments.
%
%      DAQCONTROLLERAUX('Property','Value',...) creates a new DAQCONTROLLERAUX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DaqControllerAux_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DaqControllerAux_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DaqControllerAux

% Last Modified by GUIDE v2.5 16-Dec-2011 10:33:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DaqControllerAux_OpeningFcn, ...
                   'gui_OutputFcn',  @DaqControllerAux_OutputFcn, ...
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


% --- Executes just before DaqControllerAux is made visible.
function DaqControllerAux_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DaqControllerAux (see VARARGIN)

% Choose default command line output for DaqControllerAux
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DaqControllerAux wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DaqControllerAux_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function nCycles_Callback(hObject, eventdata, handles)
% hObject    handle to nCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nCycles as text
%        str2double(get(hObject,'String')) returns contents of nCycles as a double
    genericCallback(hObject);


% --- Executes during object creation, after setting all properties.
function nCycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function currentCycle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function currentCycle_Callback(hObject, eventdata, handles)
% hObject    handle to currentCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentCycle as text
%        str2double(get(hObject,'String')) returns contents of currentCycle as a double



function timerPeriod_Callback(hObject, eventdata, handles)
% hObject    handle to timerPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timerPeriod as text
%        str2double(get(hObject,'String')) returns contents of timerPeriod as a double
    global state AIOBJ
    genericCallback(hObject);
    set(AIOBJ, 'timerPeriod', state.DaqControllerAux.timerPeriod);


% --- Executes during object creation, after setting all properties.
function timerPeriod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timerPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
