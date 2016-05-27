% Aircraft Performance Analysis
% Author: Declan Walsh
% script that analyses a planes basic performance for AERO3660

clear all
close all

%% LOAD DATA
name = 'BF-109'; % name of plane must be same as csv data stored in
str = sprintf('%s.csv', name);
data = load(str);

%% AIRCRAFT PROPERTIES
S = data(1); % area of wing
b = data(2); % span of wing
e = data(3); % Oswald span efficiency factor of wing
mass = data(4); % fully loaded weight of aircraft (kg)
Cdo = data(5); % zero lift drag
Vmin = data(6); % stall speed in m/s
Vmax = data(7); % max speed in m/s

g = 9.81; % gravitational acceleration
MS_TO_KNOTS = 1.94384; % conversion ratio from m/s to knots
KILO = 1000;

W = mass * g; % calculates the weight of the aircraft in N
Wend = 0.5 * W; % assume 50% of aircraft is fuel/ordance
AR = b^2/S; % aspect ratio of wing
rho = 1.225; % sea level density in kg.m^-3
WL = W/S; % wing loading
k = 1/(pi*AR*e); % span efficiency factor
Np = 0.8; % propulsive efficiency

v = linspace(Vmin, Vmax, 100);

%% DRAG ANALYSIS

q = 0.5*rho*v.^2; % dynamic pressure

Di = k*W^2./(q*S); % induced drag
De = q*S*Cdo; % zero lift drag
D =  De + Di; % total drag

figure
hold on
plot(v, D);
plot(v, Di, 'r--');
plot(v, De, 'k--');
legend('Total Drag', 'Induced Drag', 'Zero Lift Drag');
xlabel('Velocity (m/s)');
ylabel('Drag (N)');
strTitleD = sprintf('Effect of speed on drag for %s', name);
title(strTitleD);
xlim([Vmin, Vmax]);

%% POWER ANALYSIS
% minimum power does not occur at minimum drag 

Pi = Di.*v/KILO; % power required to overcome induced drag
Pe = De.*v/KILO; % power required to overcome zero lift drag
P =  D.*v/KILO; % power required to overcome total drag

figure
hold on
plot(v, P);
plot(v, Pi, 'r--');
plot(v, Pe, 'k--');
legend('Total Power Required', 'Induced Drag Power Required', 'Zero Lift Drag Power Required');
xlabel('Velocity (m/s)');
ylabel('Power Required (kW)');
strTitleP = sprintf('Effect of speed on power required for %s', name);
title(strTitleP);
xlim([Vmin, Vmax]);

%% LIFT DRAG RATIOS

CL = W./(S*q); % CL required for steady, level flight at given speed
CD = D./(S*q); % using the earlier drag analysis

LDpow = (CL.^(3/2))./CD;
LDglide = CL./CD;
LDcruise = (CL.^(1/2))./CD;

figure
hold on
plot(v, LDpow, 'b--');
plot(v, LDglide, 'r--');
plot(v, LDcruise, 'k--');
legend('Power Ratio (n=1.5)', 'Glide Ratio (n=1)', 'Cruise Ratio (n=0.5)');
xlabel('Velocity (m/s)');
ylabel('L^n/D');
strTitleLD = sprintf('Lift-drag ratios for %s', name);
title(strTitleLD);
xlim([Vmin, Vmax]);

%% RANGE AND ENDURANCE ANALYSIS

%Eprop = 
%Ejet = ;

%Rprop = ;
%Rjet = ;
LDmax = sqrt(Cdo*pi*AR*e)/(2*Cdo);