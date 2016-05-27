%%
% TURBINE PARAMETERS
nTurbine = [1, 0.9, 0.9, 0.8]'; % turbine efficiency
nCompressor = [1, 0.9, 0.8, 0.9]'; % compressor efficiency

T4 = 1000+273; % temperature of fluid at turbine entry
T2 = 15+273; % ambient temperature at 32,000 feet (cruising altitude) 

rP = linspace(0, 70, 100); % pressure ratio of engine
k = 1.4; % heat capacity ratio = Cp/Cv
rT = T4/T2;

%%
% THERMAL EFFICIENCY EQUATION
nThermalNum1 = (nTurbine) * (rT.*(1-1./(rP.^((k-1)/k)))); 
nThermalNum2 = (1./nCompressor) * (rP.^((k-1)/k)-1);
nThermalDen = rT - nThermalNum2 - 1;

nThermal = (nThermalNum1 - nThermalNum2)./nThermalDen;

[~, idealRPidx] = max(nThermal');
idealRP = rP(idealRPidx); % the pressure ratio for given configuration that maximises the efficiency can be numerically fonud
% can alternately be found by differentiating
%%
% PLOT
plot(rP, nThermal);
legend('100% Both', '90% Both', '90% Turbine and 80% Compressor', '80% Turbine and 90% Compressor');
xlabel('Pressure Ratio');
ylabel('Thermal Efficiency of the Engine');
title('Variation of Engine Effiency with Varying Component Efficiencies');
ylim([0, 1]);
text(5, 0.1, 'Turbine efficiency has more of an impact than compressor efficiency');