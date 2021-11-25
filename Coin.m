function varargout = Coin(varargin)
% COIN MATLAB code for Coin.fig
%      COIN, by itself, creates a new COIN or raises the existing
%      singleton*.
%
%      H = COIN returns the handle to a new COIN or the handle to
%      the existing singleton*.
%
%      COIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COIN.M with the given input arguments.
%
%      COIN('Property','Value',...) creates a new COIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Coin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Coin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Coin

% Last Modified by GUIDE v2.5 24-Nov-2021 22:52:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Coin_OpeningFcn, ...
                   'gui_OutputFcn',  @Coin_OutputFcn, ...
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


% --- Executes just before Coin is made visible.
function Coin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Coin (see VARARGIN)

% Choose default command line output for Coin
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

[imname,impath]=uigetfile({'*.jpg;*.png;*.jpeg'});
I=imread([impath,'/',imname]);

flg=ndims(I);             %imgenin renk uzayý test ediliyor. ( Testing the color space)

if flg==3
    I=rgb2gray(I);
end

[h,w]=size(I);

c = edge(I, 'canny',0.3);  % mcanny kenar algýlama fonksiyonu (Mcanny edge detection)
                             % ikili imge olarak kenar tespiti (binary edges)

se = strel('disk',2);      %
I2 = imdilate(c,se);       % pupil bölgesinin tespiti aþamasý 
                %

d2 = imfill(I2, 'holes');  % pupil bölgesi alan tespiti
        %

Label=bwlabel(d2,4);

a1=(Label==1);


D1 = bwdist(~a1);           % computing minimal euclidean distance to non-white pixel       % 
[xc1 yc1 r1]=merkz(D1);h
f1=coindetect(r1)

axes(handles.axes1);
imshow(I);           %Show thw coin scanned

axes(handles.axes2);
imshow(d2);           %Show how we detect value

set(handles.edit1,'String',f1); %display coin value


% UIWAIT makes Coin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Coin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
