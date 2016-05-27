T_TURBINE_MAX = 1850; % maximum turbine entry temperature with current technology
T_COMPRESSOR_MAX = 1400; % maximum compressor exit temperature with current technology (no cooling air = lower max T)

M = 0.8; % Mach number of jet
T_static = -51 + 273.15; % T (K) of tropopause

% isentropic index
k_air = 1.4;
k_exhaust = 1.3;

% polytopic efficiencies
nP_c = 0.9; % compressor
nP_t = 0.9; % turbine

m_norm_choked = (k_exhaust/sqrt(k_exhaust - 1)) * ((k_exhaust+1)/2)^(-(k_exhaust+1)/(2*(k_exhaust-1)));

% stagnation T at inlet (ambient T with compressibility accounted for)
T02 = T_static*(1+((k_air-1)/2)*(M^2));

A_turbine_nozzle_ratio = 0.5;

%P_compressor_ratio = 