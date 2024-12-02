%% This function will take and return relative uncertainty in 
%   Airspeed
function e_Va = relative_uncertainty_Va(data)

e_Va = sqrt((1/2)^2.*data.e_q.^2 + (1/2)^2.*data.e_rho.^2 );


%% See the contributions for each one

% Prop_Contr_MatrixVA = zeros(length(e_Va),3);
% Contribution_MatrixVA = zeros(length(e_Va),3);
% for idx = 1:length(e_Va)
%     e_Vai = sqrt((1/2)^2.*data.e_q(idx).^2 + (1/2)^2.*data.e_rho(idx).^2 );
%     Contribution_MatrixVA(idx,:) = [(1/2)^2.*data.e_q(idx).^2,(1/2)^2.*data.e_rho(idx).^2,e_Vai^2];
%     Prop_Contr_MatrixVA(idx,:) = Contribution_MatrixVA(idx,:)./e_Vai.^2;
% 
% end
% disp(':P')
% 
% 
% VA_Medians = [median(Prop_Contr_MatrixVA(:,1)) median(Prop_Contr_MatrixVA(:,2))];
% VA_vars = categorical({'V_a','\rho'})
% VA_cat = categorical({'Wind Tunnel'})
% figure;  bar(VA_vars,VA_Medians)
% figure; bar(VA_cat,VA_Medians,"stacked")

