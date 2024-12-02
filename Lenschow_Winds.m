function [u,v,w,ws,wdir]=Lenschow_Winds(data)

%% NOTE THAT THE INERTIAL VELOCITY SHOULD BE IN THE ENU (East, North, Up) FRAMEWORK %%
%% Typically, this means that the GPS-reported V_d needs to be inverted as the "v_z" input into this code %%

% Input values required 
TAS = data.tas;
pitch = data.pitch;
roll = data.roll;
yaw = data.yaw;
v_x = data.vy; % This is flipped becuase of vectorNAV alignment
v_y = data.vx;  % This is flipped becuase of vectorNAV alignment
v_z = data.vz;
alpha = data.alpha.*180/pi;
beta = data.beta.*180/pi;


% Set this if there is an offset between the angle of the MHP and the
% x-axis of the body frame (a pitch offset)
base_aoa = 0;
L = 0;

pitch=pitch-base_aoa;
D=(1+(tand(alpha)).^2+(tand(beta)).^2).^(1/2);

% wind

uterm1=sind(yaw).*cosd(pitch);
uterm2=tand(beta).*(cosd(yaw).*cosd(roll)+sind(yaw).*sind(pitch).*sind(roll));
uterm3=tand(alpha).*(sind(yaw).*sind(pitch).*cosd(roll)-cosd(yaw).*sind(roll));
uterm4=0; 
u = -1.*TAS.*D.^-1.*(uterm1+uterm2+uterm3)+v_x-uterm4;

vterm1=cosd(yaw).*cosd(pitch);
vterm2=tand(beta).*(sind(yaw).*cosd(roll)-cosd(yaw).*sind(pitch).*sind(roll));
vterm3=tand(alpha).*(cosd(yaw).*sind(pitch).*cosd(roll)+sind(yaw).*sind(roll));
vterm4=0; 
v = -1.*TAS.*D.^-1.*(vterm1-vterm2+vterm3)+v_y-vterm4;

wterm1=sind(pitch);
wterm2=tand(beta).*cosd(pitch).*sind(roll);
wterm3=tand(alpha).*cosd(pitch).*cosd(roll);
wterm4=0; 
w = -1.*TAS.*D.^-1.*(wterm1-wterm2-wterm3)+v_z+wterm4;

ws=(u.^2+v.^2).^.5;
wdir=270-atan2d(v,u);
wdir(wdir>=360)=wdir(wdir>=360)-360;
