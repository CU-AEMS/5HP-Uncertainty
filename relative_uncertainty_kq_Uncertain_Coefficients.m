%% This function will take Coefficients, KA and KB and return uncertainty in 
%   kb
function e_kq = relative_uncertainty_kq_Uncertain_Coefficients(data)

KA = data.k_alpha;
KB = data.k_beta;
XKq = data.XKq;

e_ka = data.e_KA;
e_kb = data.e_KA;

e_XKq0 = data.e_XKq0;
e_XKq1 = data.e_XKq1;
e_XKq2 = data.e_XKq2;
e_XKq3 = data.e_XKq3;
e_XKq4 = data.e_XKq4;
e_XKq5 = data.e_XKq5;
e_XKq6 = data.e_XKq6;
e_XKq7 = data.e_XKq7;
e_XKq8 = data.e_XKq8;


XKq0 = XKq(1); XKq1 = XKq(2);XKq2 = XKq(3);XKq3 = XKq(4);XKq4 = XKq(5);XKq5 = XKq(6);XKq6 = XKq(7);XKq7 = XKq(8);XKq8 = XKq(9);

WQKA = (KA.*(XKq3 + XKq4.*KB + XKq5.*KB.^2 + 2.*XKq6.*KA + 2.*XKq7.*KA.*KB+2.*XKq8.*KA.*KB.^2))./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);


WQKB = (KB.*(XKq1 + 2.*XKq2.*KB+XKq4.*KA+2.*XKq5.*KA.*KB+XKq7.*KA.^2 + XKq8.*KA.^2.*KB))./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);

WQXKq0 = (XKq0)./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);
WQXKq1 = (XKq1.*KB)./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);
WQXKq2 = (XKq2.*KB.^2)./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);
WQXKq3 = (XKq3.*KA)./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);
WQXKq4 = (XKq4.*KA.*KB)./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);
WQXKq5 = (XKq5.*KA.*KB.^2)./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);
WQXKq6 = (XKq6.*KA.^2)./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);
WQXKq7 = (XKq7.*KA.^2.*KB)./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);
WQXKq8 = (XKq8.*KA.^2.*KB.^2)./(XKq0 + XKq1.*KB + XKq2.*KB.^2 + XKq3.*KA + XKq4.*KA.*KB + XKq5.*KA.*KB.^2 + XKq6.*KA.^2 + XKq7.*KA.^2.*KB + XKq8.*KA.^2.*KB.^2);


e_kq = sqrt(WQKA.^2.*e_ka.^2 + WQKB.^2.*e_kb.^2 + WQXKq0.^2.*e_XKq0.^2 + WQXKq1.^2.*e_XKq1.^2+ WQXKq2.^2.*e_XKq2.^2+ WQXKq3.^2.*e_XKq3.^2+ WQXKq4.^2.*e_XKq4.^2+ WQXKq5.^2.*e_XKq5.^2+ WQXKq6.^2.*e_XKq6.^2+ WQXKq7.^2.*e_XKq7.^2+ WQXKq8.^2.*e_XKq8.^2);

