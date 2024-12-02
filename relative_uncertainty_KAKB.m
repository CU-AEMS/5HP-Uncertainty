%% This Code takes in pressure values, absolute uncertainty in pressure,
%  and returns the relative uncertainty in KA KB for each measurement
function [e_KA,e_KB,e_P0,e_P1,e_P2,e_P3,e_P4] = relative_uncertainty_KAKB(data)

% Since we don't have average data we aren't reporting random error
% We could compute the random error for the calibration process

% First compute the relative error in each pressure port (P0-P4)

% Different Pressure differential sensor for center port because it
% experiences a larger range (BlackSwift has them listed as 6.22 for P0 and
% 2.49 for the rest of them)

Absolute_Error_P0 = data.Absolute_Error_P(1);
Absolute_Error_P14 = data.Absolute_Error_P(2);

e_P0S = Absolute_Error_P0./data.P0;
    e_P1S = Absolute_Error_P14./data.P1;
    e_P2S = Absolute_Error_P14./data.P2;
    e_P3S = Absolute_Error_P14./data.P3;
    e_P4S = Absolute_Error_P14./data.P4;
    
    % Random error from the wind tunnel data calibration
    e_P0R = 0.0019;
    e_P1R = 0.0206;
    e_P2R = 0.0259;
    e_P3R = 0.0203;
    e_P4R = 0.0089;
     
    % Total Relative Error 
    e_P0 = sqrt(e_P0R.^2 + e_P0S.^2);
    e_P1 = sqrt(e_P1R.^2 + e_P1S.^2);
    e_P2 = sqrt(e_P2R.^2 + e_P2S.^2);
    e_P3 = sqrt(e_P3R.^2 + e_P3S.^2);
    e_P4 = sqrt(e_P4R.^2 + e_P4S.^2);
    
    
% Compute the weights/influence for each pressure measurement 

% For KA
WAP0 = (-4.*data.P0)./(4.*data.P0-(data.P1+data.P2+data.P3+data.P4));
WAP1 = (data.P1.*(4.*data.P0 - 2.*data.P3 - data.P2 - data.P4))./((data.P1-data.P3).*(4.*data.P0-(data.P1+data.P2+data.P3+data.P4)));
WAP2 = (data.P2)./(4.*data.P0 - (data.P1 + data.P2 + data.P3 + data.P4));
WAP3 = (data.P3.*(-4.*data.P0 + 2.*data.P3 + data.P2 + data.P4))./((data.P1-data.P3).*(4.*data.P0-(data.P1+data.P2+data.P3+data.P4)));
WAP4 = (data.P4)./(4.*data.P0 - (data.P1 + data.P2 + data.P3 + data.P4));

%For KB
WBP0 = (-4.*data.P0)./(4.*data.P0 - (data.P1 + data.P2 + data.P3 + data.P4));
WBP1 = (data.P1)./(4.*data.P0 - (data.P1 + data.P2 + data.P3 + data.P4));
WBP2 = (data.P2.*(4.*data.P0 - 2.*data.P4 - data.P1 -data.P3))./((data.P2 - data.P4).*(4.*data.P0 - (data.P1 + data.P2 + data.P3 + data.P4)));
WBP3 = (data.P3)./(4.*data.P0 - (data.P1 + data.P2 + data.P3 + data.P4));
WBP4 = (data.P4.*(-4.*data.P0 + 2.*data.P2 + data.P1 + data.P3))./((data.P2 - data.P4).*(4.*data.P0 - (data.P1 + data.P2 + data.P3 + data.P4)));


% Now its time to find the relative error in KA and KB

e_KA = sqrt(WAP0.^2.*e_P0 + WAP1.^2.*e_P1.^2 + WAP2.^2.*e_P2.^2+ WAP3.^2.*e_P3.^2+ WAP4.^2.*e_P4.^2);
e_KB = sqrt(WBP0.^2.*e_P0 + WBP1.^2.*e_P1.^2 + WBP2.^2.*e_P2.^2+ WBP3.^2.*e_P3.^2+ WBP4.^2.*e_P4.^2);