HEIGHT_MIN = 0;
HEIGHT_MAX = 15000;

z = linspace(HEIGHT_MIN, HEIGHT_MAX, 100);
T_static = atmosisa(z);
k_air = 1.4;

M_subsonic = 0.3;
M_transonic = 0.8;
M_supersonic = 1.5;

T_stagnation_subsonic = T_static*(1+((k_air-1)/2)*(M_subsonic^2));
T_stagnation_transonic = T_static*(1+((k_air-1)/2)*(M_transonic^2));
T_stagnation_supersonic = T_static*(1+((k_air-1)/2)*(M_supersonic^2));

figure;
hold on
plot(z, T_static, 'g-');
plot(z, T_stagnation_subsonic, 'b-');
plot(z, T_stagnation_transonic, 'r-');
plot(z, T_stagnation_supersonic, 'k-');
legend('Static T - No Velocity (M = 0)', 'Subsonic (M = 0.3)', 'Transonic (M = 0.8)', 'Supersonic (M = 1.5)');
xlabel('Height Above Sea Level (m)');
ylabel('Stagnation T (K)');
title('Effect of Altitude on Inlet Stangation T at Various Mach Numbers')
