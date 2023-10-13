function varargout = GUIMatlabVer2(varargin)
%GUIMATLABVER2 MATLAB code file for GUIMatlabVer2.fig
%      GUIMATLABVER2, by itself, creates a new GUIMATLABVER2 or raises the existing
%      singleton*.
%
%      H = GUIMATLABVER2 returns the handle to a new GUIMATLABVER2 or the handle to
%      the existing singleton*.
%
%      GUIMATLABVER2('Property','Value',...) creates a new GUIMATLABVER2 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUIMatlabVer2_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUIMATLABVER2('CALLBACK') and GUIMATLABVER2('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUIMATLABVER2.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIMatlabVer2

% Last Modified by GUIDE v2.5 12-Oct-2023 16:45:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIMatlabVer2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIMatlabVer2_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before GUIMatlabVer2 is made visible.
function GUIMatlabVer2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for GUIMatlabVer2
handles.output = hObject;
load net64sgdm1;
handles.net = net;
axes1 = gca; 
axes1.XAxis.Visible = 'off'; %remove x-axis
axes1.YAxis.Visible = 'off'; %remove y-axis

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIMatlabVer2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIMatlabVer2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in inputgambar_button.
function inputgambar_button_Callback(hObject, eventdata, handles)
% hObject    handle to inputgambar_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn pn] = uigetfile('*.png; *.jpg','select jpg file');
str = strcat(pn,fn);

set(handles.inputgambar_value,'string',str);

% Mendapatkan nama file tanpa ekstensi
[~, baseFileName, ~] = fileparts(str);

fileinfo = imfinfo(str);
namafile = fullfile(pn, baseFileName);
format = fileinfo.Format;
lebar = fileinfo.Width;
tinggi = fileinfo.Height;


set(handles.nama_value,'String', namafile);
set(handles.format_value,'String', format);
set(handles.lebar_value,'String', lebar);
set(handles.tinggi_value,'String', tinggi);

I =imread(str);
handles.I = I;
imshow(I,'Parent',handles.axes1);

guidata(hObject, handles);
net = handles.net;
I= handles.I;
I = imresize(I,[64,64],'nearest');
[Pred,scores] = classify(net,I);
scores = max(double(scores*100));
set(handles.klasifikasi_value,'string',join([string(Pred)]));
set(handles.akurasi_value,'string',join([string(scores),'%']));


function inputgambar_value_Callback(hObject, eventdata, handles)
% hObject    handle to inputgambar_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputgambar_value as text
%        str2double(get(hObject,'String')) returns contents of inputgambar_value as a double


% --- Executes during object creation, after setting all properties.
function inputgambar_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputgambar_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hapus_button.
function hapus_button_Callback(hObject, eventdata, handles)
% hObject    handle to hapus_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.inputgambar_value,'String',[]) %open 
set(handles.nama_value,'String', []);
set(handles.format_value,'String', []);
set(handles.lebar_value,'String', []);
set(handles.tinggi_value,'String', []);
set(handles.klasifikasi_value,'String',[]) 
set(handles.akurasi_value,'String',[]) 

axes(handles.axes1)
cla reset


function format_value_Callback(hObject, eventdata, handles)
% hObject    handle to format_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of format_value as text
%        str2double(get(hObject,'String')) returns contents of format_value as a double


% --- Executes during object creation, after setting all properties.
function format_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to format_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function klasifikasi_value_Callback(hObject, eventdata, handles)
% hObject    handle to klasifikasi_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of klasifikasi_value as text
%        str2double(get(hObject,'String')) returns contents of klasifikasi_value as a double


% --- Executes during object creation, after setting all properties.
function klasifikasi_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to klasifikasi_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function akurasi_value_Callback(hObject, eventdata, handles)
% hObject    handle to akurasi_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of akurasi_value as text
%        str2double(get(hObject,'String')) returns contents of akurasi_value as a double


% --- Executes during object creation, after setting all properties.
function akurasi_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to akurasi_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nama_value_Callback(hObject, eventdata, handles)
% hObject    handle to nama_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nama_value as text
%        str2double(get(hObject,'String')) returns contents of nama_value as a double


% --- Executes during object creation, after setting all properties.
function nama_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nama_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lebar_value_Callback(hObject, eventdata, handles)
% hObject    handle to lebar_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lebar_value as text
%        str2double(get(hObject,'String')) returns contents of lebar_value as a double


% --- Executes during object creation, after setting all properties.
function lebar_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lebar_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tinggi_value_Callback(hObject, eventdata, handles)
% hObject    handle to tinggi_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tinggi_value as text
%        str2double(get(hObject,'String')) returns contents of tinggi_value as a double


% --- Executes during object creation, after setting all properties.
function tinggi_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tinggi_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
