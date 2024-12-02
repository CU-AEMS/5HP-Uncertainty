clear;close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This script is the driver for evaluating wind measurement uncertainty
%%% during sUAS flight with Multi-hole probe (MHP)
%%% data : coefficient files, flight files
%%% This file saves all processed variables under the field "data"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the directory
myFolder = pwd;

% Choose the sample flight (This was the probe used in the TRACER flight)
Flight_File = strcat(myFolder,'\tracer_20220629_134952_gps_L0'); 
% Load the sample flight data (this example is from TRACER in 2022
% This is a structure with all the variables on it as fields.
load(Flight_File) 

% Load the MHP coefficients
coeff=load(strcat(myFolder,'\Probe_92_Coeffs.mat'));
data.XA=coeff.CA;data.XB=coeff.CB;data.XKq=coeff.CQ;
% Shift P0 using offset from correlation between reference pitot static and
% MHP during wind tunnel calibration
P0_offset = 23.8784;

% Load MHP Coefficient Uncertainties
Coeff_Uncertain_File = strcat(myFolder,'\Probe_92_Coefficient_Uncertainties')
load(Coeff_Uncertain_File);
  


%%
% synchronize all the data
% Since there were different onboard insturments it's important to make
% sure all the data is aligned. Syncronized to the insturment with the
% slowest data aquisition rate (in this case the VectorNAV-300.

% MHP Pressure values values
data.P0=interp1(miniflux.mhp.sample_time,miniflux.mhp.dynamic_press_0,miniflux.vn.sample_time);
% inlcude offset from calibration
data.P0=data.P0+P0_offset;
data.P1=interp1(miniflux.mhp.sample_time,miniflux.mhp.dynamic_press_1,miniflux.vn.sample_time);
data.P2=interp1(miniflux.mhp.sample_time,miniflux.mhp.dynamic_press_2,miniflux.vn.sample_time);
data.P3=interp1(miniflux.mhp.sample_time,miniflux.mhp.dynamic_press_3,miniflux.vn.sample_time);
data.P4=interp1(miniflux.mhp.sample_time,miniflux.mhp.dynamic_press_4,miniflux.vn.sample_time);


% Static Pressure and Air Temperature
data.static_press=interp1(miniflux.mhp.sample_time,miniflux.mhp.static_press,miniflux.vn.sample_time);
data.air_temp    =interp1(miniflux.mhp.sample_time,miniflux.mhp.air_temp,miniflux.vn.sample_time);
data.RSS421P = data.static_press.*100;
data.T  = data.air_temp+273.15;

%% Process all the Flight Variables and compute inertial wind components 
    

% VN
data.timeflight=(miniflux.vn.sample_time.*1e-6)/60;% flight time in minutes
data.GPS1       = miniflux.vn.time_gps(1:10)./10^9-6*60*60; % GPS Time in Epoch time
data.GPS_time   = datetime(data.GPS1,'convertfrom','epochtime','Epoch','1980-01-06');% date time 
data.pitch      = miniflux.vn.pitch; % degrees
data.roll       = miniflux.vn.roll; % degrees
data.yaw        = miniflux.vn.yaw;data.yaw(data.yaw<0)=data.yaw(data.yaw<0)+360; % degrees (0-360)
data.lat        = miniflux.vn.lat;
data.lon        = miniflux.vn.lon;
data.alt        = miniflux.vn.alt;
data.agl        = data.alt - mean(data.alt(1)); % Above ground level  (assuming starting at ground level)
data.roll_rate  = miniflux.vn.ang_rates_x;
data.pitch_rate = miniflux.vn.ang_rates_y;
data.yaw_rate = miniflux.vn.ang_rates_z;

data.vy = miniflux.vn.vel_y; % y inertial velocity
data.vx = miniflux.vn.vel_x;% x inertial velocity
data.vz = -miniflux.vn.vel_z;% z inertial velocity

% Find the inflight time
data.inFlight = find(data.agl > 20); % once its above 10 m we will count it as flight

% or Specify time series
inFlight1 = find(data.timeflight > 20);
inFlight2 = find(data.timeflight < 110);
data.inFlight = intersect(inFlight1,inFlight2);
  
    
%% Compute nondimensional values using MHP data

data.DP_TYall = (data.P1 +  data.P2 +  data.P3 +  data.P4)/4;
data.k_alpha = (data.P1 - data.P3) ./ (data.P0 - data.DP_TYall);
data.k_beta  = (data.P2 - data.P4) ./ (data.P0 - data.DP_TYall);



    

    
%% Define Uncertainties associated with MHP

% Pressure sensor uncertainties
data.Absolute_Error_P = [6.22,2.49]; 

% XA Coefficient uncertainty
data.e_XA0 = Uncertainty.e_CA(1);
data.e_XA1 = Uncertainty.e_CA(2);
data.e_XA2 = Uncertainty.e_CA(3);
data.e_XA3 = Uncertainty.e_CA(4);
data.e_XA4 = Uncertainty.e_CA(5);
data.e_XA5 = Uncertainty.e_CA(6);
data.e_XA6 = Uncertainty.e_CA(7);
data.e_XA7 = Uncertainty.e_CA(8);
data.e_XA8 = Uncertainty.e_CA(9);

% XB Coefficient uncertainty
data.e_XB0 = Uncertainty.e_CB(1);
data.e_XB1 = Uncertainty.e_CB(2);
data.e_XB2 = Uncertainty.e_CB(3);
data.e_XB3 = Uncertainty.e_CB(4);
data.e_XB4 = Uncertainty.e_CB(5);
data.e_XB5 = Uncertainty.e_CB(6);
data.e_XB6 = Uncertainty.e_CB(7);
data.e_XB7 = Uncertainty.e_CB(8);
data.e_XB8 = Uncertainty.e_CB(9);

% XKq Coefficient uncertainty
data.e_XKq0 = Uncertainty.e_CQ(1);
data.e_XKq1 = Uncertainty.e_CQ(2);
data.e_XKq2 = Uncertainty.e_CQ(3);
data.e_XKq3 = Uncertainty.e_CQ(4);
data.e_XKq4 = Uncertainty.e_CQ(5);
data.e_XKq5 = Uncertainty.e_CQ(6);
data.e_XKq6 = Uncertainty.e_CQ(7);
data.e_XKq7 = Uncertainty.e_CQ(8);
data.e_XKq8 = Uncertainty.e_CQ(9);
    
%%

% Propegate Uncertainty from raw differential pressures to nondimensional
% MHP values 
[data.e_KA,data.e_KB,data.e_P0,data.e_P1,data.e_P2,data.e_P3,data.e_P4] = relative_uncertainty_KAKB(data);
data.Error_KA = data.k_alpha .* data.e_KA;
data.Error_KB = data.k_beta .* data.e_KB;

% Set the polynomial order     
data.order_coef=2;
% Initialize the nondimensional MHP value 
data.k_TY=NaN(length(data.k_alpha),(data.order_coef+1).^2);
% For each datapoint generate the polynomial corresponding to the
% non-dimensional MHP values
for i = 1:length(data.k_TY)
    data.k_TY(i,:) = generate_measurement(data,i);%sqrt(length(c_alpha)) - 1);
end

%    
% Compute Angle of Attack, Angle of Side Slip, Airspeed, Kq, dynamic
% pressure, and air density 
[data.alpha,data.beta,data.tas,data.kq,data.q,data.rho]=anglestas(data);
 

%% account for upwash effects

    % % Add upwash effects alpha upwash (post Uncertainty manuscript work)
    % Alpha = (1/1.19).*(data.alpha.*180./pi) - (0.6/1.19);
    % data.alpha = Alpha.*pi./180;


%%
% Compute the wind compnents u,v,w, the wind speed and wind direction
[data.wu,data.wv,data.ww,data.wHSpeed,data.wdir]=Lenschow_Winds(data);
% compute the GPS direction from the inertial velocities 
data.gps_dir = atan2d(data.vy,data.vx);
data.gps_dir(data.gps_dir < 0)=data.gps_dir(data.gps_dir < 0)+360;
% Compute the crab angle (difference between course angle and heading)
data.crab = data.gps_dir - data.yaw;
data.wSpeed = sqrt(data.wu.^2 + data.wv.^2 + data.ww.^2);
    
    
    
%% Define Uncertainty Propegation values for Angle of Attack and Angle of Side 
% Slip, Airspeed, and inertial wind components


% Using Radians for the Uncertainty Propegation 
data.yawd = data.yaw; % yaw in degrees
data.yaw = data.yaw.*pi./180; % yaw in radians (needed for uncertainty propegation)
data.pitchd = data.pitch; % pitch in degrees
data.pitch = data.pitch.*pi./180; % pitch in radians
data.rolld = data.roll; % roll in degrees
data.roll = data.roll.*pi./180; % roll in radians


% Define Absolute uncertainties for VectorNAV data
data.Absolute_yaw = 2*pi/180; % From Vector Nav data sheet (0.2 or 2)
data.Absolute_pitch = 0.5*pi/180; % Says 0.5 or 0.03 degrees can change
data.Absolute_roll = 0.5*pi/180;
data.Absolute_vx = 0.05; % m/s from Vector Nav Sheet
data.Absolute_vy = 0.05; % m/s from Vector Nav Sheet
data.Absolute_vz = 0.05; % m/s from Vector Nav Sheet (But I question it)
data.Va = data.tas;

% Compute the relative uncertainty for angle of attack, angle of side slip,
% and Kq
[data.e_Alpha,data.e_Beta] = relative_uncertainty_Alpha_Beta_Uncertain_Coefficients(data);
[data.e_kq] = relative_uncertainty_kq_Uncertain_Coefficients(data);

%%
% % If including the upwash effects
% % Then the uncertainty propegation is
% data.e_Alpha = (data.alpha./1.19)./(data.alpha./1.19 - 0.6*pi/214.2).*data.e_Alpha;
%%

% Compute the relative uncertianty for dynamic pressure, air density and
% airspeed
[data.e_q] = relative_uncertainty_q(data);
[data.e_rho, data.e_T, data.e_RSS421P] = relative_uncertainty_rho(data);
[data.e_Va] = relative_uncertainty_Va(data);

% Compute the relative uncertianty for the wind components and wind
% direction
[data.e_wu, data.e_wv, data.e_ww] = full_relative_uncertainty_winds(data);
data.e_wdir = relative_uncertainty_wdir(data);

% Compute total wind speed uncertainty and horizontal wind speed
% uncerainty 
data.e_Wtot = sqrt((data.wu.^2./(data.wu.^2 + data.wv.^2 + data.ww.^2)).*data.e_wu.^2 + (data.wv.^2./(data.wu.^2 + data.wv.^2+ data.ww.^2)).*data.e_wv.^2 + (data.ww.^2./(data.wu.^2 + data.wv.^2+ data.ww.^2)).*data.e_ww.^2);
data.e_WHoriz = sqrt((data.wu.^2./(data.wu.^2 + data.wv.^2)).*data.e_wu.^2 + (data.wv.^2./(data.wu.^2 + data.wv.^2)).*data.e_wv.^2);



% Recompute Total Wind Speed, Horizontal Wind Speed and Angle of Attack and
% Side slip in degrees 


data.W_tot = sqrt(data.wu.^2 + data.wv.^2 + data.ww.^2);
data.W_Horiz = sqrt(data.wu.^2 + data.wv.^2);
data.Alpha = data.alpha.*180./pi;
data.Beta = data.beta.*180./pi;



% Compute absolute uncertainties for the wind components,
data.R_u = abs(data.wu).*data.e_wu;
data.R_v = abs(data.wv).*data.e_wv;
data.R_w = abs(data.ww).*data.e_ww;
% Compute absolute uncertainty for total and horizontal wind speed
data.R_tot = data.W_tot.*data.e_Wtot;
data.R_Horiz = data.W_Horiz.*data.e_WHoriz;
data.R_wdir = abs(data.wdir).*data.e_wdir;
% Compute absoute uncertainty for angle of attack, side slip and airspeed
data.R_B = abs(data.Beta).*data.e_Beta;
data.R_A = abs(data.Alpha).*data.e_Alpha;
data.R_tas = abs(data.tas).*data.e_Va;




% Choose a boundary for certainty ussing the total wind speed uncertainty
% (in ths case uncertainty (1 sigma) < 50 m/s)
data.more_certain = find(data.R_tot <= 50);
% Intersect this with the data defined as "in flight"
data.more_certain = intersect(data.more_certain,data.inFlight);

%    more_certain = inFlight;
%% Plotting the data


% First a summary of the flight
   
   figure(100); subplot(1,2,1); hold on; grid minor;
   xlabel('Longitude (degrees)'); ylabel('Latitude (degrees)'); zlabel('Altitude (m)');title('Flight Path');
   scatter3(data.lon(data.inFlight),data.lat(data.inFlight),data.alt(data.inFlight),ones(1,length(data.inFlight)),data.timeflight(data.inFlight));
   C = colorbar; C.Label.String ='Flight Time (minutes)'; axis equal;
   % Making a quiver plot
   qstep = 1000; % only use every 1000th data point so you can see the arrows
   qscale = 15; % scaling factor
   quiver3(data.lon(data.more_certain(1:qstep:end)),data.lat(data.more_certain(1:qstep:end)),data.alt(data.more_certain(1:qstep:end)),data.wu(data.more_certain(1:qstep:end)),data.wv(data.more_certain(1:qstep:end)),data.ww(data.more_certain(1:qstep:end)),min([range(data.lat(data.more_certain(1:qstep:end))),range(data.lon(data.more_certain(1:qstep:end)))])/max(data.wSpeed(data.more_certain(1:qstep:end)))/qscale);
   
   % Altitude Time Series   
   subplot(1,2,2); hold on; grid minor; 
   xlabel('Time (minutes)'); ylabel('AGL Altitude (m)'); title('Altitude vs Time');
   plot(data.timeflight(data.inFlight),data.agl(data.inFlight),'k .','MarkerSize',15);
 %%  Wind Time Series Time Series 
   
color1 = [60/256 70/256 200/256];
color11 = color1.*1.2;
color2 = [106/256 159/256 108/256];
color22 = [217/256 231/256 217/256];
color3 = [239/256 122/256 5/256];
color33 = [255/256 196/256 47/256]; 


 
figure(100); hold on;
   
time_conf = [data.timeflight(data.more_certain);data.timeflight(data.more_certain(end:-1:1))];   
axx1 = subplot(3,1,1); hold on; grid minor; plot(data.timeflight(data.more_certain),data.wu(data.more_certain),'.','color',color1); 
Uconf = [data.wu(data.more_certain)+ 2.*data.R_u(data.more_certain) ; data.wu(data.more_certain(end:-1:1))- 2.*data.R_u(data.more_certain(end:-1:1))];
p = fill(time_conf,Uconf,'red');
p.FaceColor = color11;
p.EdgeColor = 'none';
p.FaceAlpha = 0.65; % Transparency
set(gca,'XLim',[min(data.timeflight(data.more_certain)) max(data.timeflight(data.more_certain))]);
ylabel('U Wind (m/s)'); legend({'U Wind Estimate','+/-2 \sigma'})

axx2 = subplot(3,1,2); hold on; grid minor; plot(data.timeflight(data.more_certain),data.wv(data.more_certain),'.','color',color2);
Vconf = [data.wv(data.more_certain)+ 2.*data.R_v(data.more_certain) ; data.wv(data.more_certain(end:-1:1))- 2.*data.R_v(data.more_certain(end:-1:1))];
p = fill(time_conf,Vconf,'red'); 
p.FaceColor = color22;
p.EdgeColor = 'none';
p.FaceAlpha = 0.65; % Transparency

ylabel('V Wind (m/s)');legend({'V Wind Estimate','+/-2 \sigma'});

axx3 = subplot(3,1,3); hold on; grid minor; plot(data.timeflight(data.more_certain),data.ww(data.more_certain),'.','color',color3);
Wconf = [data.ww(data.more_certain)+ 2.*data.R_w(data.more_certain) ; data.ww(data.more_certain(end:-1:1))- 2.*data.R_w(data.more_certain(end:-1:1))];
p = fill(time_conf,Wconf,'red');
p.FaceColor = color33;
p.EdgeColor = 'none';
p.FaceAlpha = 0.65; % Transparency
xlabel('Time (minutes)'); ylabel('W Wind (m/s)'); legend({'W Wind Estimate','+/-2 \sigma'});


linkaxes([axx1 axx2 axx3],'x')

%% Wind Rose


[figure_handle, count, speeds, directions, Table, Others] = WindRose(data.wdir(data.more_certain),data.wHSpeed(data.more_certain),'AngleNorth', 0, 'AngleEast', 90,'nDirections', 36, 'labels', {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'},'MaxFrequency', 25,'TitleString', 'Wind Rose','vWinds',[0 5 10 12.5 15 17.5 20],'LegendPosition', 'southeast', 'LegendOrientation', 'horizontal'); %



%% PDF

% Alpha Beta Va

figure; axA = subplot(3,1,1); hold on; H = histogram( data.R_A(data.inFlight),round(sqrt(length(data.inFlight))/8)-10, 'Normalization','pdf','FaceColor',[0 1 0],'BinWidth',0.01);
fd = fitdist(H.Data,'Normal'); fdx = [-1:0.0001:4]; fdy = normpdf(fdx,fd.mu,fd.sigma); plot(fdx,fdy,'- b','LineWidth',5);
xlabel('\alpha Uncertainty (degrees)');
axis([H.BinEdges(min(find(H.Values > 10^-4))) H.BinEdges(max(find(H.Values > 2*10^-3)))+0.1 0 max(H.Values)+0.05*max(H.Values)])
title('MHP Uncertainty PDFs: \alpha , \beta , V_a'); ylabel('Probability Density');
grid minor
legend('Flight Data','Normal Fit');

axB =subplot(3,1,2); hold on; H = histogram( data.R_B(data.inFlight),round(sqrt(length(data.inFlight))/8)-10, 'Normalization','pdf','FaceColor',[0 1 0],'BinWidth',0.01);
axis([H.BinEdges(min(find(H.Values > 10^-4))) H.BinEdges(max(find(H.Values > 10^-4))+1) 0 max(H.Values)+0.05*max(H.Values)])
xlabel('\beta Uncertainty (degrees)');ylabel('Probability Density');
grid minor

linkaxes([axA axB],'xy')
set(gca,'XLim',[0.1 0.9]);

subplot(3,1,3); hold on; H = histogram( data.R_tas(data.inFlight),round(sqrt(length(data.inFlight))/8)-10, 'Normalization','pdf','FaceColor',[0 1 0],'BinWidth',0.001);
fd = fitdist(H.Data,'Normal'); fdx = [0.1:0.0001:0.8]; fdy = normpdf(fdx,fd.mu,fd.sigma); plot(fdx,fdy,'- b','LineWidth',5);
axis([H.BinEdges(min(find(H.Values > 10^-4))) H.BinEdges(max(find(H.Values > 2*10^-3)))+1 0 max(H.Values)+0.05*max(H.Values)])
xlabel('V_a Uncertainty (m/s)');ylabel('Probability Density');
grid minor
set(gca,'XLim',[0.245 0.285]);

legend('Flight Data','Normal Fit')




% Wind Components and Direction

figure; axVw = subplot(3,1,1); hold on; H = histogram( data.R_w(data.inFlight),round(sqrt(length(data.inFlight))/8)-10, 'Normalization','pdf','FaceColor',[0 1 0],'BinWidth',0.005);
fd = fitdist(H.Data,'Normal'); fdx = [0.1:0.0001:1]; fdy = normpdf(fdx,fd.mu,fd.sigma); plot(fdx,fdy,'- b','LineWidth',5);
xlabel('Vertical Wind Speed Uncertainty (m/s)')
title('Wind Uncertainty PDFs')
grid minor

axHw =subplot(3,1,2); hold on; H = histogram( data.R_Horiz(data.inFlight),round(sqrt(length(data.inFlight))/8)-10, 'Normalization','pdf','FaceColor',[0 1 0],'BinWidth',0.005);
fd = fitdist(H.Data,'Normal'); fdx = [0.1:0.0001:1]; fdy = normpdf(fdx,fd.mu,fd.sigma); plot(fdx,fdy,'- b','LineWidth',5);
xlabel('Horizontal Wind Speed Uncertainty (m/s)')
grid minor

linkaxes([axVw axHw],'xy')
set(gca,'XLim',[0.1 0.9]);

subplot(3,1,3); hold on; H = histogram( data.R_wdir(data.inFlight),round(sqrt(length(data.inFlight))/8)-10, 'Normalization','pdf','FaceColor',[0 1 0],'BinWidth',0.05);
xlabel('Horizontal Wind Direction Uncertainty (degrees)')
grid minor

set(gca,'XLim',[0.25 3]);






% Split by wind speed

% Wind speeds/Altitude/Shear influence the
% uncertainty in the wind direction 

WindSpeed_Threshold = 3.5;
% Find the ranges where wind speeds < 3.5 
help4 = find(data.wHSpeed <= WindSpeed_Threshold);
Help4 = intersect(help4,data.inFlight);
% Find the ranges where wind speeds < 3.5
help5 = find(data.wHSpeed > WindSpeed_Threshold);
Help5 = intersect(help5,data.inFlight);
% Find where wind direction uncertainty < 10 degrees
R_realistic = find(data.R_wdir < 10);
Realistic_Flight = intersect(data.inFlight,R_realistic);
% insersect these sets
Help5 = intersect(R_realistic,Help5);
Help4 = intersect(R_realistic,Help4);


figure;  H = histogram( data.R_wdir(Realistic_Flight),round(sqrt(length(Realistic_Flight))/8), 'Normalization','pdf','FaceColor',[0 1 0],'BinWidth',0.05);
     axis([H.BinEdges(min(find(H.Values > 10^-4))) H.BinEdges(max(find(H.Values > 2*10^-3)))+1 0 max(H.Values)+0.05*max(H.Values)])
    xlabel('Horizontal Wind Direction Uncertainty (degrees)')
    title('Horizontal Wind Direction Uncertainty PDF')
    grid minor

 figure; axSp1 = subplot(2,1,1); H = histogram( data.R_wdir(Help5),round(sqrt(length(Help5))/8), 'Normalization','pdf','FaceColor',[0 1 0],'BinWidth',0.05);
     axis([H.BinEdges(min(find(H.Values > 10^-4))) H.BinEdges(max(find(H.Values > 2*10^-3)))+1 0 max(H.Values)+0.05*max(H.Values)])
    xlabel('Horizontal Wind Direction Uncertainty (degrees)')
    title('Horizontal Wind Direction Uncertainty PDF: Wind Speed > 3.5 m/s')
    grid minor
axSp2 = subplot(2,1,2); H = histogram( data.R_wdir(Help4),round(sqrt(length(Help4))/8), 'Normalization','pdf','FaceColor',[0 1 0],'BinWidth',0.05);
    axis([H.BinEdges(min(find(H.Values > 10^-4))) H.BinEdges(max(find(H.Values > 2*10^-3)))+1 0 max(H.Values)+0.05*max(H.Values)])
    xlabel('Horizontal Wind Direction Uncertainty (degrees)')
    title('Horizontal Wind Direction Uncertainty PDF: Wind Speed <= 3.5 m/s')
    grid minor

linkaxes([axSp1 axSp2],'xy')
set(gca,'XLim',[0 4]);

%%
% MHP Pressure time series

% Plot the time series of the MHP Pressures
color1 = [86/256 186/256 176/256];
color2 = [132/256 24/256 132/256];
color3 = [250/256 100/256 0/256];
color4 = [256/256 239/256 18/256];
color5 = [0/256 102/256 0/256];
figure(); hold on; grid minor;
set(gcf, 'Position', get(0, 'Screensize'));
plot(-10,0,'.','MarkerSize',20,'color',color5); plot(-10,0,'.','MarkerSize',20,'color',color1);plot(-10,0,'.','MarkerSize',20,'color',color2);plot(-10,0,'.','MarkerSize',20,'color',color3);plot(-10,0,'.','MarkerSize',20,'color',color4);
plot(data.timeflight,data.P0,'.','MarkerSize',5,'color',color5);
plot(data.timeflight,data.P1,'.','MarkerSize',5,'color',color1)
plot(data.timeflight,data.P2,'.','MarkerSize',5,'color',color2)
plot(data.timeflight,data.P3,'.','MarkerSize',5,'color',color3)
plot(data.timeflight,data.P4,'.','MarkerSize',5,'color',color4)
set(gca,'XLim',[min(data.timeflight) max(data.timeflight)])
legend({'P0','P1','P2','P3','P4'})
xlabel('Flight Time (minutes)');
ylabel('MHP Port Pressure (Pa)');