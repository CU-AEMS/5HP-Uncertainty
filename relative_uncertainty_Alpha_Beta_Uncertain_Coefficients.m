%% This function takes the uncertainty in KA, KB and Pressures and Calibration Coefficients and outputs
%  the uncertainty in Angle of Attack (alpha) and Side Slip angle (Beta)
function [e_Alpha,e_Beta] = relative_uncertainty_Alpha_Beta_Uncertain_Coefficients(data)

XA = data.XA;
XB = data.XB;

e_KA = data.e_KA;
e_KB = data.e_KB;

e_XA0 = data.e_XA0;
e_XA1 = data.e_XA1;
e_XA2 = data.e_XA2;
e_XA3 = data.e_XA3;
e_XA4 = data.e_XA4;
e_XA5 = data.e_XA5;
e_XA6 = data.e_XA6;
e_XA7 = data.e_XA7;
e_XA8 = data.e_XA8;


e_XB0 = data.e_XB0;
e_XB1 = data.e_XB1;
e_XB2 = data.e_XB2;
e_XB3 = data.e_XB3;
e_XB4 = data.e_XB4;
e_XB5 = data.e_XB5;
e_XB6 = data.e_XB6;
e_XB7 = data.e_XB7;
e_XB8 = data.e_XB8;


% Here are the coefficients
XA0 = XA(1); XA1 = XA(2);XA2 = XA(3);XA3 = XA(4);XA4 = XA(5);XA5 = XA(6);XA6 = XA(7);XA7 = XA(8);XA8 = XA(9);
XB0 = XB(1); XB1 = XB(2);XB2 = XB(3);XB3 = XB(4);XB4 = XB(5);XB5 = XB(6);XB6 = XB(7);XB7 = XB(8);XB8 = XB(9);

KA = data.k_alpha;
KB = data.k_beta;

% Find the weights of KA and KB

WAKA = (KA.*(XA3 + XA4.*KB + XA5.*KB.^2 + 2.*XA6.*KA + 2.*XA7.*KA.*KB+2.*XA8.*KA.*KB.^2))./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAKB = (KB.*(XA1 + 2.*XA2.*KB+XA4.*KA+2.*XA5.*KA.*KB+XA7.*KA.^2 + XA8.*KA.^2.*KB))./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAXA0 = (XA0)./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAXA1 = (XA1.*KB)./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAXA2 = (XA2.*KB.^2)./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAXA3 = (XA3.*KA)./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAXA4 = (XA4.*KA.*KB)./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAXA5 = (XA5.*KA.*KB.^2)./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAXA6 = (XA6.*KA.^2)./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAXA7 = (XA7.*KA.^2.*KB)./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);
WAXA8 = (XA8.*KA.^2.*KB.^2)./(XA0 + XA1.*KB + XA2.*KB.^2 + XA3.*KA + XA4.*KA.*KB + XA5.*KA.*KB.^2 + XA6.*KA.^2 + XA7.*KA.^2.*KB + XA8.*KA.^2.*KB.^2);

WBKA = (KA.*(XB3 + XB4.*KB + XB5.*KB.^2 + 2.*XB6.*KA + 2.*XB7.*KA.*KB+2.*XB8.*KA.*KB.^2))./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBKB = (KB.*(XB1 + 2.*XB2.*KB+XB4.*KA+2.*XB5.*KA.*KB+XB7.*KA.^2 + XB8.*KA.^2.*KB))./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBXB0 = (XB0)./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBXB1 = (XB1.*KB)./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBXB2 = (XB2.*KB.^2)./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBXB3 = (XB3.*KA)./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBXB4 = (XB4.*KA.*KB)./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBXB5 = (XB5.*KA.*KB.^2)./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBXB6 = (XB6.*KA.^2)./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBXB7 = (XB7.*KA.^2.*KB)./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);
WBXB8 = (XB8.*KA.^2.*KB.^2)./(XB0 + XB1.*KB + XB2.*KB.^2 + XB3.*KA + XB4.*KA.*KB + XB5.*KA.*KB.^2 + XB6.*KA.^2 + XB7.*KA.^2.*KB + XB8.*KA.^2.*KB.^2);


e_Alpha = sqrt(WAKA.^2.*e_KA.^2 + WAKB.^2.*e_KB.^2+ WAXA0.^2.*e_XA0.^2 + WAXA1.^2.*e_XA1.^2+ WAXA2.^2.*e_XA2.^2+ WAXA3.^2.*e_XA3.^2+ WAXA4.^2.*e_XA4.^2+ WAXA5.^2.*e_XA5.^2+ WAXA6.^2.*e_XA6.^2+ WAXA7.^2.*e_XA7.^2+ WAXA8.^2.*e_XA8.^2);
e_Beta = sqrt(WBKA.^2.*e_KA.^2 + WBKB.^2.*e_KB.^2+ WBXB0.^2.*e_XB0.^2 + WBXB1.^2.*e_XB1.^2+ WBXB2.^2.*e_XB2.^2+ WBXB3.^2.*e_XB3.^2+ WBXB4.^2.*e_XB4.^2+ WBXB5.^2.*e_XB5.^2+ WBXB6.^2.*e_XB6.^2+ WBXB7.^2.*e_XB7.^2+ WBXB8.^2.*e_XB8.^2);

