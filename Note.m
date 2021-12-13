 function varargout = Note(varargin)
%NOTE M-file for Note.fig
%      NOTE, by itself, creates a new NOTE or raises the existing
%      singleton*.
%
%      H = NOTE returns the handle to a new NOTE or the handle to
%      the existing singleton*.
%
%      NOTE('Property','Value',...) creates a new NOTE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Note_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      NOTE('CALLBACK') and NOTE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in NOTE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Note

% Last Modified by GUIDE v2.5 24-Nov-2021 00:24:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Note_OpeningFcn, ...
                   'gui_OutputFcn',  @Note_OutputFcn, ...
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


% --- Executes just before Note is made visible.
function Note_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Note
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Note wait for user response (see UIRESUME)
% uiwait(handles.figure1);
[imname,impath]=uigetfile({'*.jpg;*.png'});
note=imread([impath,'/',imname]);



c_count = imcrop(note,[43 115 36 230]);
%figure , imshow(c_count);

bw_note = rgb2gray(c_count); %making the image b and w

I=bw_note;
flg=ndims(I);             %imgenin renk uzayý test ediliyor. ( Testing the color space)

if flg==3
    I=rgb2gray(I);
end

[h,w]=size(I);
%figure;imshow(I);

c = edge(I, 'canny',0.3);  % mcanny kenar algýlama fonksiyonu (Mcanny edge detection)
%figure; imshow(c);         % ikili imge olarak kenar tespiti (binary edges)

se = strel('disk',2);      %
I2 = imdilate(c,se);       % pupil bölgesinin tespiti aþamasý 
%imshow(I2);                %

d2 = imfill(I2, 'holes');  % pupil bölgesi alan tespiti
%figure, imshow(d2);        %

cc = bwconncomp(d2, 4);
cc.NumObjects;

axes(handles.axes3);
imshow(note);           %Show thw note scanned

axes(handles.axes2);
imshow(d2);           %Show how we detect value

axes(handles.axes4);
imshow(c_count);           %Show how we detect value

%detect the value of the note
v=notedetect(cc.NumObjects);
set(handles.edit2,'String',v); %display it


% Fake detection @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@




% Fake detection @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if (v == 100)
A=imread('100.jpg'); 

note=imresize(note,[size(A,1) size(A,2)] );

a = rgb2gray(A);

%figure,imshow(p);




a2_str = imcrop(a,[1000 30 300 80]);   % lion
p = imcrop(note,[1000 30 300 80]);   
%figure,imshow(p2_str);

p2_str = rgb2gray(p);

%decompose into hsv

hsvA = rgb2hsv(A);
hsvp = rgb2hsv(note);


%figure('Name','real image hsv');
%imshow([hsvImageReal(:,:,1) hsvImageReal(:,:,2) hsvImageReal(:,:,3)]);
%title('Real');
%figure('Name','fake image hsv');
%imshow([hsvImageFake(:,:,1) hsvImageFake(:,:,2) hsvImageFake(:,:,3)]);
%title('Fake');

crophsvA = imcrop(hsvA,[1000 30 300 80]);%crop A
crophsvp = imcrop(hsvp,[1000 30 300 80]);%crop p

axes(handles.axes1);
imshow(p);

satThresh = 0.3;
valThresh = 0.9;
BWA = (crophsvA(:,:,2) > satThresh & crophsvA(:,:,3) < valThresh);
%figure('Name','lion');
%subplot(1,2,1);
%imshow(BWA);
%title('Real');
BWp = (crophsvp(:,:,2) > satThresh & crophsvp(:,:,3) < valThresh);
%figure('Name','lion');
%subplot(1,2,2);
%imshow(BWp);
%title('fake');

%close

se = strel('disk',1);
BWAclose = imclose(BWA,se);
BWpclose = imclose(BWp,se);
%figure('Name','closed lion');
%subplot(1,2,1);
%imshow(BWAclose);
%title('cReal');
%subplot(1,2,2);
%imshow(BWpclose);
%title('cFake');

BWAclose = ~BWAclose;
BWpclose = ~BWpclose;

%clean 
areaopenA = bwareaopen(BWAclose, 15);


areaopenp = bwareaopen(BWpclose, 15);

title('Real');
axes(handles.axes5);
imshow(areaopenp);
title('Selected');



%[~,countA] = bwarea(areaopenA);
%[~,countp] = bwarea(areaopenp);

%conA = bwconncomp(areaopenA,26);
%conp = bwconncomp(areaopenp,26);


areaA = bwarea(areaopenA);
areap = bwarea(areaopenp);

%areaA = regionprops(conA,'basic')
%disp(areaA);

%areap = regionprops(conp,'basic')
%disp(areap);

co=corr2 (a2_str, p2_str); 

%disp(['The total number of black lines for the real note is: ' num2str(countA)]);
%disp(['The total number of black lines for the fake note is: ' num2str(countp)]);

if (co>=0.5 && areaA > 0 && areap > 0.7*areaA  )
    %disp ('correlevance of lion >0.7');
    if (areaA > 0 && areap > 0.7*areaA )
       % disp ('currency is legitimate');
        set(handles.edit1,'String','Real');
    else
       % disp ('currency is fake');
        set(handles.edit1,'String','Fake');
    end;
else
    %disp ('correlevance of lion < 0.7');
    disp ('currency is fake');
    set(handles.edit1,'String','currency is fake');
    
end;
end 



% --- Outputs from this function are returned to the command line.
function varargout = Note_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
