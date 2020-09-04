%% ASKING THE USER TO ENTER THE T.L LENGHT IN KM
prompt   = {'HOW LONG IS THE LINE (Km)'};        %The question
dlgtitle = 'length of the T.L';                  %dialogue box title
dims     = [1,50];                               %box dimension
answer1  = inputdlg(prompt,dlgtitle,dims);       %taking the answer
L        = str2num(answer1{1})                   %converting from string to number and store in L
%%
if L<51 || L>240                                 %checking if L is within medium range 
f = msgbox('can not be solve by medium model');  %if not print this msg
return  
end
%%
%ASKING THE USER FOR THE I/P
prompt   = {'R (ohm/km)','X (ohm/km)','Y (simon/km)','TOTAL POWER S_r (VA)','pf_r lag','Vline_r (volt)'};      
dlgtitle = 'Inputs and load data';                                      %dialogue box title
dims     = [1 50];                                                      %box dimension
answer   = inputdlg(prompt,dlgtitle,dims);                              %storing in answer array
r        = str2num(answer{1});                                            
x        = str2num(answer{2});
y        = str2num(answer{3});
Sr       = str2num(answer{4});
pf       = str2num(answer{5});
VLr      = str2num(answer{6});

%%
%%BASIC CALCULATIONS APPLIED ON THE TWO MODELS
Pr   = Sr*pf 
IRph = (Sr/(sqrt(3)*VLr))*exp(i*(-1*acos(pf)))
VRph = VLr/sqrt(3)
R    = r*L
X    = i*x*L
Y    = i*y*L
Z    = R + X

%%
%%ASKING THE USER WHICH MODEL HE/SHE PREFER
answer0 = questdlg('WHICH SOLVING MODEL DO YOU WANT?', ...   %question box and its choices   
	'MODEL', ...
	'T-MODEL','PI-MODEL','T-MODEL');
% Handling the response
switch answer0
    case 'T-MODEL'                                           %flag=0 indicating solving by T MODEL
        flag=0;                           
    case 'PI-MODEL'                                          %flag=1 indicating solving by PI-model
        flag=1;
end
%%
if flag == 0                     %T-MODEL
    A  = 1+(Z*Y)/2
    B  = Z*(1+(Z*Y)/4)
    C  = Y
    D  = A
 VSph  = (A*VRph) + (B*IRph)
 ISph  = (C*VRph) + (D*IRph)
 theta = angle (VSph) + (-1)*angle(ISph)
 PFs   = cos(theta)
 Ps    = 3*(abs(VSph))*(abs(ISph)*(PFs))
 P     = Ps - Pr
 eff   = (Pr/Ps)*100
 reg   = ((abs(VSph) - abs(VRph))/abs(VSph))*100
end
%%
if flag==1                       %PI-MODEL
    
    A  = 1+(Z*Y)/2
    B  = Z
    C  = Y*(1+(Z*Y)/4)
    D  = A
 VSph  = (A*VRph) + (B*IRph)
 ISph  = (C*VRph) + (D*IRph)
 theta = angle (VSph) + (-1)*angle(ISph)
 PFs   = cos(theta)
 Ps    = 3*(abs(VSph))*(abs(ISph)*(PFs))
 P     = Ps - Pr
 eff   = (Pr/Ps)*100
 reg   = ((abs(VSph) - abs(VRph))/abs(VSph))*100
end
%%
if eff >= 90                           %efficiency condition 
    m  = 'efficiency is accepted'         %string to be printed if condition met
else
    m  = 'efficiency is not accepted'     %string to be printed if condition not met
end
if reg <= 5                            %similarly the regulation
    a  = 'regulation is accepted ' 
else
    a  = 'regulation is not accepted'
end
%% 
%THE O/P MSG
z =msgbox(sprintf('Vs=%g v \n Is=%g A \n Ps=%g W \n Power_Losses=%g W \n your %s \n your %s',VSph,ISph,Ps,P,m,a),'output')
O = findall(z, 'Type', 'Text');                    %get handle to text within msgbox
O.FontSize = 9;                                   %Change the font size