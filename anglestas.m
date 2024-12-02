function [alpha_1,beta_1,tas_1,kq_1,q1,rho1]=anglestas(data)
    
    alpha_1=data.k_TY*data.XA; % with loaded calibration coefficients
    beta_1=data.k_TY*data.XB;
    kq_1=data.k_TY*data.XKq;
    
    q1=data.P0-kq_1.*(data.P0-data.DP_TYall);
    R_constant=287.058; % J kg-1 K-1
    rho1 = data.static_press.*100./... %pressinterp
        (R_constant.*(data.air_temp+273.15));%1.14; %tempinterp
    tas_1=real(sqrt(2*q1./rho1));

    
end