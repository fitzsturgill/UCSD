function varargout = sgBrowser(varargin)
% SGBROWSER M-file for sgBrowser.fig
%      SGBROWSER, by itself, creates a new SGBROWSER or raises the existing
%      singleton*.
%
%      H = SGBROWSER returns the handle to a new SGBROWSER or the handle to
%      the existing singleton*.
%
%      SGBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SGBROWSER.M with the given input arguments.
%
%      SGBROWSER('Property','Value',...) creates a new SGBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sgBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sgBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sgBrowser

% Last Modified by GUIDE v2.5 02-Dec-2011 10:20:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sgBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @sgBrowser_OutputFcn, ...
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

% --- Executes just before sgBrowser is made visible.
function sgBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sgBrowser (see VARARGIN)

% Choose default command line output for sgBrowser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = sgBrowser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;







function sg_Clim_Callback(hObject, eventdata, handles)
% hObject    handle to sg_Clim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sg_Clim as text
%        str2double(get(hObject,'String')) returns contents of sg_Clim as a double
    global state
    genericCallback(hObject);
    high = num2str(get(hObject, 'String'));
    set(state.mcViewer.sg_axis, 'Clim', [0 high]);


% --- Executes during object creation, after setting all properties.
function sg_Clim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sg_Clim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sg_TW_Callback(hObject, eventdata, handles)
% hObject    handle to sg_TW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sg_TW as text
%        str2double(get(hObject,'String')) returns contents of sg_TW as a double
    genericCallback(hObject);
    mcUpdateSgStructure;
    mcUpdateSgFigure;


% --- Executes during object creation, after setting all properties.
function sg_TW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sg_TW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sg_p_Callback(hObject, eventdata, handles)
% hObject    handle to sg_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sg_p as text
%        str2double(get(hObject,'String')) returns contents of sg_p as a double
    global state
    p = round(str2num(get(hObject, 'String')));
    % ensure that at least 1 taper is used
    if p >= 2*state.mcViewer.sg_TW - 1
        p = 2*state.mcViewer.sg_TW - 2;
    end
    set(hObject, 'String', num2str(p));
    genericCallback(hObject);
    mcUpdateSgStructure;
    mcUpdateSgFigure;    


% --- Executes during object creation, after setting all properties.
function sg_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sg_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sg_width_Callback(hObject, eventdata, handles)
% hObject    handle to sg_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sg_width as text
%        str2double(get(hObject,'String')) returns contents of sg_width as a double
    genericCallback(hObject);
    mcUpdateSgStructure;
    mcUpdateSgFigure;    


% --- Executes during object creation, after setting all properties.
function sg_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sg_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sg_step_Callback(hObject, eventdata, handles)
% hObject    handle to sg_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sg_step as text
%        str2double(get(hObject,'String')) returns contents of sg_step as a double
    genericCallback(hObject);
    mcUpdateSgStructure;
    mcUpdateSgFigure;    


% --- Executes during object creation, after setting all properties.
function sg_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sg_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sg_ClimSlider_Callback(hObject, eventdata, handles)
% hObject    handle to sg_ClimSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global state
    genericCallback(hObject);
    high = get(hObject, 'Value');
    set(state.mcViewer.sg_axis, 'Clim', [0 high]);    


% --- Executes during object creation, after setting all properties.
function sg_ClimSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sg_ClimSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function sg_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sg_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate sg_axis


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sg_channel_Callback(hObject, eventdata, handles)
% hObject    handle to sg_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sg_channel as text
%        str2double(get(hObject,'String')) returns contents of sg_channel as a double
    genericCallback(hObject);
    mcUpdateSgStructure;
    mcUpdateSgFigure;    


% --- Executes during object creation, after setting all properties.
function sg_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sg_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
