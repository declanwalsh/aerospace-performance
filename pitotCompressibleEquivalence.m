% script that demostrates the equivalence graphically of two different compressible speed measurement equations
% Author: Declan Walsh
% Last Modified: 10/3/2016

close all
clear all

k = 1.4;
M = linspace(0.5, 5, 50);

% Rayleigh pitot tube formula - WORKS
ratioRPT = (((k+1)^2 * M.^2)./(4*k*M.^2 - 2*(k-1))).^(k/(k-1)) .* ((1-k) + 2*k*M.^2)/(k+1);

% other equation Olsen went through - ERROR
ratioOTHER = (((k-1)^(k+1))./(2*k*M.^2-k+1) .* ((M.^2)/2).^k).^(1/(k-1));

% simplified form of other equation - WORKS
ratioSIMPLE = (166.9*M.^7)./((7*M.^2 - 1).^2.5);

figure;
hold on
plot(M, ratioRPT, 'b-');
plot(M, ratioOTHER, 'r*');
plot(M, ratioSIMPLE, 'g--');
legend('Rayleight Pitot Tube Equation', 'Other Equation', 'Simplified Other')
xlabel('M');
ylabel('Measured Pressure Ratio');
hold off