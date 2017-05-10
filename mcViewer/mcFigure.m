function varargout = mcFigure(varargin)
% MCFIGURE M-file for mcFigure.fig
%      MCFIGURE, by itself, creates a new MCFIGURE or raises the existing
%      singleton*.
%
%      H = MCFIGURE returns the handle to a new MCFIGURE or the handle to
%      the existing singleton*.
%
%      MCFIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCFIGURE.M with the given input arguments.
%
%      MCFIGURE('Property','Value',...) creates a new MCFIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mcFigure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mcFigure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mcFigure

% Last Modified by GUIDE v2.5 28-Sep-2011 10:35:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mcFigure_OpeningFcn, ...
                   'gui_OutputFcn',  @mcFigure_OutputFcn, ...
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


% --- Executes just before mcFigure is made visible.
function mcFigure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mcFigure (see VARARGIN)

% Choose default command line output for mcFigure
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mcFigure wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mcFigure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
