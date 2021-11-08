function varargout = GUI_signal_detector(varargin)
% GUI_SIGNAL_DETECTOR MATLAB code for GUI_signal_detector.fig
%      GUI_SIGNAL_DETECTOR, by itself, creates a new GUI_SIGNAL_DETECTOR or raises the existing
%      singleton*.
%
%      H = GUI_SIGNAL_DETECTOR returns the handle to a new GUI_SIGNAL_DETECTOR or the handle to
%      the existing singleton*.
%
%      GUI_SIGNAL_DETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SIGNAL_DETECTOR.M with the given input arguments.
%
%      GUI_SIGNAL_DETECTOR('Property','Value',...) creates a new GUI_SIGNAL_DETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_signal_detector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_signal_detector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_signal_detector

% Last Modified by GUIDE v2.5 19-Feb-2020 17:38:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_signal_detector_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_signal_detector_OutputFcn, ...
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


% --- Executes just before GUI_signal_detector is made visible.
function GUI_signal_detector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_signal_detector (see VARARGIN)

% Choose default command line output for GUI_signal_detector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global ModelName
global h_1
global hAxes
global xData
global yData  

global text_Detector
global text_freqency

ModelName = 'signal_detector_V2';
xData = [];
yData = [];
hAxes = handles.axes1;
h_1 = line( hAxes,0,0,'Color','y');
grid(hAxes, 'minor')
set(hAxes,'XLim',[1 2^12],'YLim',[-60 0]);

text_Detector = handles.text_Detector;
text_freqency = handles.text_freq;



% UIWAIT makes GUI_signal_detector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_signal_detector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Start_button.
function Start_button_Callback(hObject, eventdata, handles)
% hObject    handle to Start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ModelName
open_system(ModelName);
set_param(ModelName,'BlockReduction','off');
set_param(ModelName,'StartFcn','localAddEventListener');
set_param(ModelName, 'SimulationCommand', 'start');

% --- Executes on button press in Stop_botton.
function Stop_botton_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_botton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ModelName
set_param(ModelName,'SimulationCommand','stop')
% close_system(ModelName)
close all
clear
clc

function [eventhandle] = localAddEventListener
 
eventhandle(1) = add_exec_event_listener('signal_detector_V2/Gain', ...
                                        'PostOutputs', @localEventListener);
eventhandle(2) = add_exec_event_listener('signal_detector_V2/GainTranssmition', ...
                                        'PostOutputs', @localEventListener_1);
eventhandle(3) = add_exec_event_listener('signal_detector_V2/GainFreq', ...
                                        'PostOutputs', @localEventListener_2);
                                    
                                    
function localEventListener(block, eventdata)
 
global h_1
global hAxes
global xData
global yData  

    x = block.CurrentTime;
    y1_n = block.InputPort(1).Data;

    
    yData = 10*log10( abs(fftshift(fft(y1_n)))/length(y1_n) );
    xData = 1:length(yData);
    cla(hAxes)
    h_1 = line( hAxes,xData,yData,'Color','b');
    drawnow
    
    
    function localEventListener_1(block, eventdata)
        global text_Detector
        index = block.InputPort(1).Data;
        
        if index == 1
            text_Detector.String = 'Blue Transmission';
            text_Detector.BackgroundColor = 'blue';
        elseif index == -1
            text_Detector.String = 'Red Transmission';
            text_Detector.BackgroundColor = 'red';
        elseif index == 0
             text_Detector.String = 'Nan';
             text_Detector.BackgroundColor = 'black';
        end
        
        function localEventListener_2(block, eventdata)
        global text_freqency
        index = block.InputPort(1).Data;
        if index ~= 0
            freq = round(index/1e3)/1e3 + 0.003;
        else
            freq = 0;
        end
        text_freqency.String = [num2str(freq),' [MHz]'];
        
  
