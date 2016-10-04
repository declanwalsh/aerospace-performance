% script for AERO3110 to maximise fuel tank size
% Author: Declan Walsh
% Last Modified: 8/8/2016

%% SETUP GEOMETRY
airfoilData = load('airfoil.csv'); % import airfoil points

% minimal increase in accuracy after 50
NUM_POINTS = 500;

% format data into separate variables
xPercentage = airfoilData(:,1);
x = airfoilData(:,2);
yUpper = airfoilData(:,3);
yLower = airfoilData(:,4);

plot(x, yUpper, x, yLower)
axis equal

assert(length(yLower) == length(yUpper), 'Equal number of upper and lower y co-ordinates required');
assert(length(x) == length(yUpper), 'Equal number of x, y co-ordinates required');
DEGREE_FIT = 8;

coeffUpper = polyfit(x, yUpper, DEGREE_FIT);
coeffLower = polyfit(x, yLower, DEGREE_FIT);

xFull = linspace(min(x), max(x), NUM_POINTS);
yUpperFull = polyval(coeffUpper, xFull);
yLowerFull = polyval(coeffLower, xFull);

%% OFFSET
% offset the airofoil curve to account for thickness
[xUpperOff, yUpperOff] = fcnlineoff(xFull, yUpperFull, t_skin);
[xLowerOff, yLowerOff] = fcnlineoff(xFull, yLowerFull, t_skin);

yUpperOff = fliplr(yUpperOff(1, NUM_POINTS + 1:2*NUM_POINTS));
xUpperOff = fliplr(xUpperOff(1, NUM_POINTS + 1:2*NUM_POINTS));
yLowerOff = yLowerOff(1, 1:NUM_POINTS);
xLowerOff = xLowerOff(1, 1:NUM_POINTS);

yLowerOffBelowMin = (yLowerOff > (min(yLower) + yBounds));
yLowerOffCorr = yLowerOffBelowMin.*yLowerOff + (min(yLower) + yBounds).*~yLowerOffBelowMin;
yUpperOffBelowMin = (yUpperOff > (min(yLower) + yBounds));
yUpperOffCorr = yUpperOffBelowMin.*yUpperOff + (min(yLower) + yBounds).*~yUpperOffBelowMin;


figure
hold on;
axis equal;
%plot(xUpperOff, yUpperOff, 'b-')
plot(xUpperOff, yUpperOffCorr, 'k-', 'LineWidth', 2)
plot(xFull, yUpperFull, 'r-')
%plot(xLowerOff, yLowerOff, 'b-')
plot(xLowerOff, yLowerOffCorr, 'k-', 'LineWidth', 2)
plot(xFull, yLowerFull, 'r-')
xlabel('X (absolute from leading edge) (m)')
ylabel('Y (absolute from leading chord) (m)')
title('Offset curve check');

maxDiff = max(abs(xUpperOff - xLowerOff)) % this should be less than 0.1mm to minimise error
MAX_DIFF_TOL = 1e-3;
assert(maxDiff < MAX_DIFF_TOL, 'Difference between offset x values is too large');

%% FIND MAXIMUM AREA
% find the maximum rectangle in the created grid of points

% uses the actual airfoil curve
% [A, xLimits, yLimits] = possibleAreasUnderCurveAlgo(xFull, yUpperFull, yLowerFull, xBounds)
% uses the offset airfoil curve
% [AOff, xLimitsOff, yLimitsOff] = possibleAreasUnderCurveAlgo(xLowerOff, yUpperOff, yLowerOff, xBounds)
% uses the offset airfoil curve
[AOffCorr, xLimitsOffCorr, yLimitsOffCorr, DEBUG] = possibleAreasUnderCurveAlgo(xUpperOff, yUpperOffCorr, yLowerOffCorr, xBounds, t_tankWall)
diff(xLimitsOffCorr)
diff(yLimitsOffCorr)

%createRect( A, xLimits, yLimits, xFull, yUpperFull, xFull, yLowerFull, 'Actual Curve');
%createRect( AOff, xLimitsOff, yLimitsOff, xUpperOff, yUpperOff, xLowerOff, yLowerOff, 'Offset Curve');
createRect( AOffCorr, xLimitsOffCorr, yLimitsOffCorr, xUpperOff, yUpperOffCorr, xLowerOff, yLowerOffCorr, 'Limited Offset Curve', xFull, yUpperFull, xFull, yLowerFull);