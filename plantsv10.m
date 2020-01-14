function varargout = plantsv10(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plantsv10_OpeningFcn, ...
                   'gui_OutputFcn',  @plantsv10_OutputFcn, ...
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
end

function plantsv10_OpeningFcn(hObject, eventdata, handles, varargin)
handles.start.Enable = 'off';
handles.stop.Enable = 'off';
handles.reset.Enable = 'off';
handles.slider1.Visible = 'off';
handles.zoom.Visible = 'off';
handles.text.String = ['Available Port:', serialportlist];
%Load Settings
t = 0; 
handles.t = t;
%Pre-store Port Information


handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes plantsv10 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

function varargout = plantsv10_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
end

%%
function slider1_Callback(hObject, eventdata, handles)
option = handles.option;
M = hObject.UserData.M;
time = handles.time;
val = round(hObject.Value);
hObject.Value = val;
if option == 'F vs M'
    plot(M(:,val),'color','b')
    xlabel('Frequency (KHz)');
    ylabel('Magnitude');
    title(['Time: ',num2str(time(1,val)/(10e+07)),'s']);
elseif option == 'T vs M'
    handles.axes1.XLim = [val val+100];
end
handles.zoom.Visible = 'on';

guidata(hObject, handles);
end

%%
function slider1_CreateFcn(hObject, eventdata, handles)
hObject.Value = 1;
hObject.SliderStep = [1/(hObject.Max-hObject.Min) 5/(hObject.Max-hObject.Min)];
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Don't edit it
end

%%
function save_Callback(hObject, eventdata, handles)
datareg = handles.datareg;
filename1=['Plants',datestr(now,30),'.txt'];
filename2=['Plants',datestr(now,30),'.png'];
%Use settings
handles.text.String = 'wait a sec!';
if isempty(datareg)
    handles.text.String ='No Data file';
else
    csvwrite(filename1,datareg);
end
new_f_handle = figure('Visible','off');
new_axes = copyobj(handles.axes1,new_f_handle); 
set(new_axes,'units','default','position','default');
file = strcat(filename2);
print(new_f_handle,'-dpng',file);
delete(new_f_handle);
handles.text.String = 'Save successfully';
guidata(hObject, handles);
end

%% Choose an existed file to plot in GUI
 function uploadfile_Callback(hObject, eventdata, handles)
handles.start.Enable = 'off';
handles.stop.Enable = 'off';
handles.reset.Enable = 'off';
datareg = [];
handles.datareg = datareg;
%Button Down Settings
[filename,pathname] = uigetfile('*.txt');
if filename ~= 0
    T = readtable([pathname filename]);
    if width(T) ~= 8 % Avoid to input wrong format data
        handles.text.String = 'Incorrect format';
    else
        handles.text.String = 'Upload successfully';
        T.Properties.VariableNames = {'t','channel','f', 'R', 'I', 'M', 'temp', 'hum'};
        [M] = plot_data(T);
        option = M{2};
        handles.option = option;
        time = M{3};
        handles.time = time;
        M = M{1};
        [~,wid] = size(M);
        if wid > 1
        set(handles.slider1,'Min',1,...
            'Max',length(M),'UserData',struct('M',M),...
            'Value',1,'SliderStep',[1/length(M) 10/length(M)]);
        handles.slider1.Visible = 'on';
        else
        end
        hObject.String = 'New file';
    end
else
    handles.text.String = 'Please choose a valid file';
end
guidata(hObject,handles);
end

%%
function start_Callback(hObject, eventdata, handles)
global b
b = 1; % Controllable constant in plotting loop
t = handles.t;
s = animatedline(handles.axes1,'Color','b');
handles.s = s;
% Use settings
if t == 0
    handles.text.String = 'Please connect to a board';
else
    write(t,'r','char');
    while 1 
        if b == 0
          break
        end
        [datareg] = plot_animated(handles);
        handles.datareg = datareg;
        guidata(hObject,handles);
    end
end
guidata(hObject,handles);
end

%%
function stop_Callback(hObject, eventdata, handles)
global b
b =0;
handles.save.Enable = 'off';
pause(0.1);
t = handles.t;
%Use settings
write(t,'q','char');
pause(1)
handles.save.Enable = 'on';
guidata(hObject,handles);
end

%%
function reset_Callback(hObject, eventdata, handles)
handles.datareg = [];
s = handles.s;
%Use setting
clearpoints(s)
handles.s = s;
rs = @start_Callback;
rs(handles.start, eventdata, handles);
guidata(hObject,handles);
end

%%
function connect_Callback(hObject, eventdata, handles)
datareg = [];
handles.datareg = datareg;
handles = rmfield(handles,'t');
%Use Setting
hObject.String = serialportlist;
portlist = hObject.String;
if isempty(portlist) == 1
    handles.text.String = 'Failed Connection';
else 
    ports = serialportlist;
    port = ports(hObject.Value);
    handles.text.String = ['Selected Port: ', port];
    t = serialport(port,38400);
    handles.t = t;
    pause(1);
    [gainSet,commandStr] = PreSetting;
    write(t, string(gainSet),'string');
    pause(1);
    write(t, commandStr,'string');
    pause(1);
    for i = 1:6
        handles.text.String = readline(t);
    end
        handles.start.Enable = 'on';
        handles.stop.Enable = 'on';
        handles.reset.Enable = 'on';
end
guidata(hObject, handles);
end

%%
function zoom_Callback(hObject, eventdata, handles)
option = handles.option;
M = handles.slider1.UserData.M;
handles.zoom.Visible = 'off';
if strcmp(option, 'F vs M')
    plot(M,'color','b')
    title('Magnitude vs Frequency');
elseif strcmp(option, 'T vs M')
    handles.axes1.XLim = [1 length(M)];
end
guidata(hObject, handles);
end

%%
function figure1_CloseRequestFcn(hObject, eventdata, handles)
clear handles
delete(hObject);
end
