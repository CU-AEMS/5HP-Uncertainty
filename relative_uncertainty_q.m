%% This function will take Pressure values, kq and their uncertainties and return uncertainty in 
%   dynamic pressure q
function e_q = relative_uncertainty_q(data)

% First lets find the weighting/influence of each variable
Wqkq = 1 - (4.* data.P0)./(4.*data.P0 - data.kq.*(data.P1 + data.P2 + data.P3 + data.P4));
WqP0 = (4.*data.P0.*(1 - data.kq))./(4.*data.P0 - data.kq.*(data.P1 + data.P2 + data.P3 + data.P4));
WqP1 = (data.P1.*data.kq)./(4.*data.P0 - data.kq.*(data.P1 + data.P2 + data.P3 + data.P4));
WqP2 = (data.P2.*data.kq)./(4.*data.P0 - data.kq.*(data.P1 + data.P2 + data.P3 + data.P4));
WqP3 = (data.P3.*data.kq)./(4.*data.P0 - data.kq.*(data.P1 + data.P2 + data.P3 + data.P4));
WqP4 = (data.P4.*data.kq)./(4.*data.P0 - data.kq.*(data.P1 + data.P2 + data.P3 + data.P4));

e_q = sqrt(Wqkq.^2.*data.e_kq.^2 + WqP0.^2.*data.e_P0.^2 + WqP1.^2.*data.e_P1.^2+ WqP2.^2.*data.e_P2.^2+ WqP3.^2.*data.e_P3.^2+ WqP4.^2.*data.e_P4.^2);



% Contribution_Matrixq = [Wqkq.^2.*data.e_kq.^2, WqP0.^2.*data.e_P0.^2, WqP1.^2.*data.e_P1.^2, WqP2.^2.*data.e_P2.^2, WqP3.^2.*data.e_P3.^2, WqP4.^2.*data.e_P4.^2];
% Prop_Contr_Matrixq = Contribution_Matrixq./median(e_q(data.inFlight).^2); 
