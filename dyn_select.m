function varargout = dyn_select(varargin)
% Begin initialization code - DO NOT EDIT
%==========================================================================
%==========================================================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dyn_select_OpeningFcn, ...
                   'gui_OutputFcn',  @dyn_select_OutputFcn, ...
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
%==========================================================================
%==========================================================================
% End initialization code - DO NOT EDIT

function dyn_select_OpeningFcn(hObject, eventdata, handles, varargin)
% General Housekeeping
%==========================================================================
InitializePsychSound();
global folder
folder = uigetdir([pwd filesep '..'], 'Please select base folder');

% Manual definitions
%--------------------------------------------------------------------------
sub         = 'dummy';   % Subject ID
run         = 1;        % Run Number
dur_exp     = 1;        % Duration of Experiment in minutes
addpath(genpath(folder));

min_f       = 500;
max_f       = 1000;        % defines deviants proportional to base freq
tone_type   = 'complex';
paradigm    = 'roving';

set(handles.min_freq, 'UserData', min_f);
set(handles.max_freq, 'UserData', max_f);
set(handles.paradigm_selection, 'UserData', paradigm);
set(handles.duration, 'UserData', dur_exp);
set(handles.tone_type, 'UserData', 'harmonic');
set(handles.participantID, 'UserData', sub);
set(handles.run_no, 'UserData', run);

% Choose default command line output for dyn_select
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dyn_select wait for user response (see UIRESUME)
% uiwait(handles.figure1);





function varargout = dyn_select_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%% Soundcheck Button
function pushbutton2_Callback(hObject, eventdata, handles)
dyn_soundcheck;




%% Define subject specific information
%==========================================================================
function participantID_Callback(hObject, eventdata, handles)
sub = get(hObject, 'String')
set(handles.participantID, 'UserData', sub);

function participantID_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function run_no_Callback(hObject, eventdata, handles)
run = str2double(get(hObject, 'String'))
set(handles.run_no, 'UserData', run);

function run_no_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% Define sound stimilus characteristics
%==========================================================================
% min_freq = Minimum Frequency
%--------------------------------------------------------------------------
function min_freq_Callback(hObject, eventdata, handles)
freq = str2double(get(hObject,'String'));
set(handles.min_freq, 'UserData', freq)

function min_freq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% max_freq = Maximum Frequency
%--------------------------------------------------------------------------
function max_freq_Callback(hObject, eventdata, handles)
freq = str2double(get(hObject,'String'));
set(handles.max_freq, 'UserData', freq)

function max_freq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tone_type_SelectionChangedFcn(hObject, eventdata, handles)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'puretone'
        set(handles.tone_type, 'UserData', 'puretone');
    case 'harmonic'
        set(handles.tone_type, 'UserData', 'harmonic');
end




%% Choose experimental paradigm to run 
%==========================================================================
function paradigm_selection_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
choice = contents{get(hObject,'Value')};
switch choice
    case 'Hierarchical Roving (long)'
        paradigm = 'hierarchical_long';
    case 'Hierarchical Roving (short)'
        paradigm = 'hierarchical_short';
    case 'Roving Oddball'
        paradigm = 'roving';
    case 'aaaaB Roving'
        paradigm = 'aaaaB';
end
set(handles.paradigm_selection, 'UserData', paradigm)

function paradigm_selection_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Define duration for experiment
%-------------------------------------------------------------------------- 
function duration_Callback(hObject, eventdata, handles)
dur_exp = str2double(get(hObject,'String'));
set(handles.duration, 'UserData', dur_exp);

function duration_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Run Experiment Button
function run_experiment_Callback(hObject, eventdata, handles)
global folder
min_f = get(handles.min_freq, 'UserData');
max_f = get(handles.max_freq, 'UserData');
paradigm = get(handles.paradigm_selection, 'UserData');
dur_exp = get(handles.duration, 'UserData');
tone_type = get(handles.tone_type, 'UserData');
sub = get(handles.participantID, 'UserData');
run = get(handles.run_no, 'UserData');

dynamite_roving(paradigm, tone_type, dur_exp, min_f, max_f, sub, run, folder);



function dob_Callback(hObject, eventdata, handles)

function dob_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function comments_Callback(hObject, eventdata, handles)

function comments_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

