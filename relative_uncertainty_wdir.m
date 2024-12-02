%% This function will take wind horizontal compontents and return uncertainty in 
%   headint
function e_wdir = relative_uncertainty_wdir(data)

wu = data.wu;
wv = data.wv;

e_wu = data.e_wu;
e_wv = data.e_wv;

Wwu = (wu .* wv)./((wu.^2 + wv.^2).*(3.*pi./2 - atan2(wv,wu)));
Wwv = (-wu .* wv)./((wu.^2 + wv.^2).*(3.*pi./2 - atan2(wv,wu)));

e_wdir = sqrt(e_wu.^2.*Wwu.^2 + e_wv.^2.*Wwv.^2);




% Contribution_MatrixWdir = [e_wu.^2.*Wwu.^2 e_wv.^2.*Wwv.^2];
% Prop_Contr_MatrixWdir = Contribution_MatrixWdir./median(e_wdir(data.inFlight)); 
% 
% 
% 
% disp('yeah');
