%% This function will take RSS421 data and return relative uncertainty in 
%   for Temperature T, pressure from RSS421, and density
function [e_rho, e_T, e_RSS421P] = relative_uncertainty_rho(data)
                    

e_T = 0.1./data.T; % NOTE: RSS421 temperature sensor provides 0.01 °C resolution and a measurement repeatability of 0.1 °C 
                   % I am using what appears to be the random error for now
e_RSS421P = 40./data.RSS421P; % NOTE: RSS421capacitive silicon pressure sensor features a 0.01 hPa resolution and repeatability of 0.4 hPa
                             % I am using what appears to be the random
                             % error for the systematic error
e_rho = sqrt(e_T.^2 + e_RSS421P.^2);