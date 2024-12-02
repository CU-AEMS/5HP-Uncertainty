%% This function will take alpha, beta, inertial velocity and euler angle 
% data and return relative uncertainty in the wind vectors 
function [e_wu, e_wv, e_ww] = full_relative_uncertainty_winds(data);

e_theta = data.Absolute_pitch./data.pitch;
e_psi = data.Absolute_yaw./data.yaw;
e_phi = data.Absolute_roll./data.roll;

e_Alpha = data.e_Alpha;
e_Beta = data.e_Beta;
e_vx   = data.Absolute_vy./data.vy;
e_vy   = data.Absolute_vx./data.vx;
e_vz   = data.Absolute_vz./data.vz;
e_Va   = data.e_Va;
Va     = data.Va;
Alpha  = data.alpha;
Beta   = data.beta;
Theta  = data.pitch;
Psi    = data.yaw;
Phi    = data.roll;
vx     = data.vy; % Note we flip x and y to get the correct corrdinate system here
vy     = data.vx; 
vz     = data.vz; % vz is already negative so we don't worry about it here


% Now lets get the coefficients 

% Wu first:


WUVa    = -(Va.*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./((vx - (Va.*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WUAlpha = (Alpha.*((Va.*(tan(Alpha).^2 + 1).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1./2) + (Va.*tan(Alpha).*(tan(Alpha).^2 + 1).*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(3/2)))./(vx - (Va.*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WUBeta  = -(Beta.*((Va.*(tan(Beta).^2 + 1).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1./2) - (Va.*tan(Beta).*(tan(Beta).^2 + 1).*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(3./2)))./(vx - (Va.*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1./2));
WUPsi   = -(Psi.*Va.*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./((vx - (Va.*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WUTheta = -(Theta.*Va.*(cos(Phi).*tan(Alpha).*cos(Theta).*sin(Psi) - sin(Psi).*sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi).*sin(Psi)))./((vx - (Va.*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WUPhi   = (Phi.*Va.*(tan(Alpha).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta))))./((vx - (Va.*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WUvx    = vx./(vx - (Va.*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
% combine
e_wu = sqrt(WUVa.^2.*e_Va.^2 + WUAlpha.^2.*e_Alpha.^2 + WUBeta.^2.*e_Beta.^2 + WUPsi.^2.*e_psi.^2 + WUTheta.^2.*e_theta.^2 + WUPhi.^2.*e_phi.^2 + WUvx.^2.*e_vx.^2);

% Wv Next:

WVVa    = -(Va.*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./((vy - (Va.*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WVAlpha = -(Alpha.*((Va.*(tan(Alpha).^2 + 1).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2) - (Va.*tan(Alpha).*(tan(Alpha).^2 + 1).*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(3/2)))./(vy - (Va.*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WVBeta  = (Beta.*((Va.*(tan(Beta).^2 + 1).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2) + (Va.*tan(Beta).*(tan(Beta).^2 + 1).*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(3/2)))./(vy - (Va.*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WVPsi   = (Psi.*Va.*(cos(Theta).*sin(Psi) - tan(Alpha).*(cos(Psi).*sin(Phi) - cos(Phi).*sin(Psi).*sin(Theta)) + tan(Beta).*(cos(Phi).*cos(Psi) + sin(Phi).*sin(Psi).*sin(Theta))))./((vy - (Va.*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WVTheta = -(Theta.*Va.*(cos(Phi).*cos(Psi).*tan(Alpha).*cos(Theta) - cos(Psi).*sin(Theta) + cos(Psi).*tan(Beta).*cos(Theta).*sin(Phi)))./((vy - (Va.*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WVPhi   = -(Phi.*Va.*(tan(Alpha).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta)) + tan(Beta).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta))))./((vy - (Va.*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WVvy    = vy./(vy - (Va.*(cos(Psi).*cos(Theta) + tan(Alpha).*(sin(Phi).*sin(Psi) + cos(Phi).*cos(Psi).*sin(Theta)) - tan(Beta).*(cos(Phi).*sin(Psi) - cos(Psi).*sin(Phi).*sin(Theta))))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
% Combine
e_wv = sqrt(WVVa.^2.*e_Va.^2 + WVAlpha.^2.*e_Alpha.^2 + WVBeta.^2.*e_Beta.^2 + WVPsi.^2.*e_psi.^2 + WVTheta.^2.*e_theta.^2 + WVPhi.^2.*e_phi.^2 + WVvy.^2.*e_vy.^2);

% Ww Last:

WWVa    = (Va.*(cos(Phi).*tan(Alpha).*cos(Theta) - sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi)))./((vz + (Va.*(cos(Phi).*tan(Alpha).*cos(Theta) - sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WWAlpha = -(Alpha.*((Va.*tan(Alpha).*(tan(Alpha).^2 + 1).*(cos(Phi).*tan(Alpha).*cos(Theta) - sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(3/2) - (Va.*cos(Phi).*cos(Theta).*(tan(Alpha).^2 + 1))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)))./(vz + (Va.*(cos(Phi).*tan(Alpha).*cos(Theta) - sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WWBeta  = -(Beta.*((Va.*tan(Beta).*(tan(Beta).^2 + 1).*(cos(Phi).*tan(Alpha).*cos(Theta) - sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(3/2) - (Va.*cos(Theta).*sin(Phi).*(tan(Beta).^2 + 1))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)))./(vz + (Va.*(cos(Phi).*tan(Alpha).*cos(Theta) - sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WWPsi   = 0;
WWTheta = -(Theta.*Va.*(cos(Theta) + cos(Phi).*tan(Alpha).*sin(Theta) + tan(Beta).*sin(Phi).*sin(Theta)))./((vz + (Va.*(cos(Phi).*tan(Alpha).*cos(Theta) - sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WWPhi   = (Phi.*Va.*(cos(Phi).*tan(Beta).*cos(Theta) - tan(Alpha).*cos(Theta).*sin(Phi)))./((vz + (Va.*(cos(Phi).*tan(Alpha).*cos(Theta) - sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2)).*(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
WWvz    = vz./(vz + (Va.*(cos(Phi).*tan(Alpha).*cos(Theta) - sin(Theta) + tan(Beta).*cos(Theta).*sin(Phi)))./(tan(Alpha).^2 + tan(Beta).^2 + 1).^(1/2));
% Combine them
e_ww = sqrt(WWVa.^2.*e_Va.^2 + WWAlpha.^2.*e_Alpha.^2 + WWBeta.^2.*e_Beta.^2 + WWPsi.^2.*e_psi.^2 + WWTheta.^2.*e_theta.^2 + WWPhi.^2.*e_phi.^2 + WWvz.^2.*e_vz.^2);
