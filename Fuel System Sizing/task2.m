% QUESTIONS
% - the component loss coefficients are very high and driving very high losses in the system
% - how to use the minimum operating temperature

close all
clear all
clc

%% CONSTANTS
HP_TO_W = 0.7457; % conversion from horsepower to kilowatts
RPM_TO_RADS = 2*pi/60; % conversion from RPM to radians per second
RPM_TO_HZ = 1/60; % conversions from cycles per minute to cycles per second
IN_TO_MM = 25.4; % conversion from inches to mm
MM_TO_M = 1/1000;
MM_TO_DM = 1/100;
DM_TO_M = 1/10;
PSI_TO_PA = 6894.76; % conversion from psi to Pascals
PA_TO_KPA = 1/1000;
W_TO_KW = 1/1000;
SEC_TO_HR = 3600;
L_TO_GAL = 0.264172; % litres to US gallons

RE_TURBULENT = 4000;
RE_LAMINAR = 2100;

g = 9.81; % gravitational acceleration (m.s^-2)

% zID
A = 3;
B = 4;
C = 1;
D = 9;
E = 4;
F = 2;
G = 3;

%% ENGINE PARAMETERS
% engine is Textron Lycoming IO-540K
% http://www.lycoming.com/Lycoming/PRODUCTS/Engines/Certified/540Series.aspx
% https://en.wikipedia.org/wiki/Lycoming_O-540

NUM_CYCLES_PER_COMBUST = 2;

hpRated = 300; % rated horsepower of engine
pRated = hpRated * HP_TO_W;

speedRatedRPM = 2700; % rated engine speed in rpm
speedRated = speedRatedRPM * RPM_TO_HZ;
cycleRated = speedRated/NUM_CYCLES_PER_COMBUST;

displacementImperial = 541.5; % engine displacement in cubic inches
displacement = displacementImperial * (IN_TO_MM)^3 * (MM_TO_DM)^3; % converted to L

compRatio = 8.7; % compression ratio of engine
fuelMixRatio = (14+0.1*G); % fuel mix ratio
volumetricEfficiency = (80 + A)/100; % in percent

injectionPressureImperial = 24;
injectionPressure = injectionPressureImperial * PSI_TO_PA * PA_TO_KPA;

pumpFlowRateRating = 1.25; % percent of maximum take-off power flow
% THIS MAY NEED TO BE 0.001 - otherwise values are 2-3 inch range instead of  
pipeInternalDiameter = 0.01 * (B + 1); % in m - may be large http://ipgparts.com/blog/fuel-line-sizing-what-size-do-i-need/
%pipeInternalDiameter = (3/8)*0.0254;
% http://www.kitplanes.com/issues/29_12/builder_spotlight/Firewall_Forward_Fuel_Systems_20625-1.html
% http://www.faa.gov/regulations_policies/handbooks_manuals/aircraft/amt_handbook/media/faa-8083-30_ch07.pdf
% http://www.enginebasics.com/Advanced%20Engine%20Tuning/Fuel%20Line%20Sizing.html
pipeLength = 6 + C; % in m
minimumOperatingTemp = -(20 + D); % in C
tankHeight = (0.5 + 0.2 * E); % in m from engine
maximumAlpha = 15; % max angle of attack in degrees

%% FUEL PARAMETERS
% fuel is AVGAS100LL
% http://www.shell.com.au/motorists/shell-fuels/msds-tds/_jcr_content/par/textimage_278c.stream/1468561712721/42cc39fc0b31146bc1c4d344c08422206521206f80d031b5f89f9b697c327c81/avgas-100ll-pds.pdf
%fuelRho = 718; % kg.m^-3 at 15C
fuelRho = 740; % kg.m^-3 at -29C
%fuelRho = 680; % kg.m^-3 at 40C

fuelSpecificEnergy = 44; % MJ.kg^-1
fuelVapPres = 44; % kPa - Reid vapour pressure = absolute vapour pressure of liquid at 100F

%airRho = 1.225; % kg.m^-3 at 15C
%airRho = 1.3413; % kg.m^-3 at -10C
%airRho = 0.846; % at service ceiling and -29C
airRho = 1.446; % at S/L and -29C
%airRho = 1.125; % kg.m^-3 at 40C

% AVGAS has no direct viscosity specifications
% http://www.shell.com/business-customers/trading-and-supply/trading/trading-material-safety-data-sheets/_jcr_content/par/expandablelist/expandablesection_1370833703.stream/1447440388224/5dae197668a9778bbc8784f2b5b121d9f29fd909e0dcea554d64f380b0462d50/mogas-avgas-100ll-0.1-percent-benzene---swest---en.pdf
fuelKinematicVisc = 1.25; % mm^2.s^-1 at -40C
%fuelKinematicVisc = 0.55;
%% PRESSURE LOSSES
% there are 4 main pressure losses outlined in the pump system

% pressure drop coefficient
valveK = 2;
flowmeterK = 6;
filterK = 25;
elbowK = 1;

% quantity
valveNum = 3;
flowmeterNum = 1;
filterNum = 1;
elbowNum = 4;

%% DESIGN FLOW RATE

fuelMixPerRev = displacement * volumetricEfficiency; % fuel and air required per engine cycle (L)
fuelPerRev = fuelMixPerRev/(1+fuelMixRatio*fuelRho/airRho); % fuel required per engine cycle (L)
fuelPerSecond = fuelPerRev * cycleRated; % fuel required per second (L.s^-1)
pumpFlowRate = fuelPerSecond * pumpFlowRateRating % minimum design fuel pumped per second (L.s^-1)
pumpFlowRateSI = pumpFlowRate * (DM_TO_M)^3; % m.s^-1

pumpFlowRateHourSI = pumpFlowRate * SEC_TO_HR * (DM_TO_M)^3
pumpFlowRateHour = pumpFlowRate * SEC_TO_HR * L_TO_GAL

pipeArea = pi*(pipeInternalDiameter/2)^2;

vFlow = pumpFlowRateSI/pipeArea % m.s^-1
% maximum fluid velocities typically less than 15 ft.s^-1 or 4.572 m.s^-1

%% DESIGN PRESSURE

totalK = valveK*valveNum + flowmeterK*flowmeterNum + filterK*filterNum + elbowK*elbowNum;
vEnergy = vFlow^2/(2*g);
componentHeadLosses = (totalK * vEnergy) % m
componentPressureLosses = totalK * fuelRho * vFlow^2/2

relComp = abs(componentHeadLosses - componentPressureLosses/(fuelRho*g))/componentHeadLosses;
assert(relComp < 0.01,' Difference in calculated losses due to components is too large');

Re = vFlow*pipeInternalDiameter/(fuelKinematicVisc*1e-6) % Reynolds number (> 4000 is turbulent and <2100 is laminar for pipe flow)
roughness = 0.025; % relative roughness of flexible straight rubber pipe with a smooth bore in mm - page 130 of Internal Flow Systems Miller
%relativeRoughness = roughness/(pipeInternalDiameter/MM_TO_M); % both in mm
relativeRoughness = 0.0015;

if(Re < RE_LAMINAR)
    disp('LAMINAR')
    f = 16/Re; % Fanning friction factor for pipe losses (valid for laminar flow in circular pipe)
elseif(Re > RE_TURBULENT)
    % https://upload.wikimedia.org/wikipedia/commons/8/80/Moody_diagram.jpg
    % use to check values for reasonableness
    disp('TURBULENT')
    f = (1/4)*((-1.8*log10(6.9/Re + (relativeRoughness/3.7)^1.11))^-1)^2; % Haaland explicit approximation used to calculate Darcy friction factor for pipe losses in turbulent flow
else
    disp('TRANSITION')
    fLam = 16/Re;
    fTurb = (1/4)*((-1.8*log10(6.9/Re + (relativeRoughness/3.7)^1.11))^-1)^2;
    f = max(fLam, fTurb);
end

pipeHeadLosses = 4*f*(pipeLength/pipeInternalDiameter)*vEnergy % Darcy friction equation

headMin = tankHeight*cosd(maximumAlpha); % physical head from tank to engine

headRequired = -(headMin - pipeHeadLosses - componentHeadLosses) % head required to overcome system losses
pressureRequired = (headRequired * fuelRho * g)*PA_TO_KPA + injectionPressure % pressure (in kPa) required to overcome losses in the system (pipe friction and minor losses)
pressureRequiredIMPERIAL = pressureRequired/(PA_TO_KPA*PSI_TO_PA)
%% DESIGN POWER
% power = mdot * g * headRequired

fuelMassFlow = pumpFlowRateSI * fuelRho;
powerRequired = (pumpFlowRate * pressureRequired) % power required in W
powerRequired2 = (fuelMassFlow * g * pressureRequired*1000/(fuelRho * g))

%% OUTPUT RESULTS
% convert results to readable table and save as CSVs

format short g

nameTruss = {'pumpFlowRate'; 'flowVelocity'; 'Re'; 'compHeadLosses'; 'pipeHeadLosses'; 'headRequired'; 'pressureReqMET'; 'pressureReqIMP'; 'powerReqMET' };
tableTruss = table(pumpFlowRate, vFlow, Re, componentHeadLosses, pipeHeadLosses, headRequired, pressureRequired, pressureRequiredIMPERIAL, powerRequired, 'VariableNames', nameTruss)

writetable(tableTruss, 'tablePump.csv');
