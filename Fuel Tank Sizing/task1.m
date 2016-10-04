% script for AERO3110 to maximise fuel tank size
% Author: Declan Walsh
% Last Modified: 8/8/2016

%% SETUP GEOMETRY
airfoilData = load('airfoil.csv'); % import airfoil points

% minimal increase in accuracy after 50
NUM_POINTS = 50;

% format data into separate variables
xPercentage = airfoilData(:,1);
x = airfoilData(:,2);
yUpper = airfoilData(:,3);
yLower = airfoilData(:,4);

assert(length(yLower) == length(yUpper), 'Equal number of upper and lower y co-ordinates required');
assert(length(x) == length(yUpper), 'Equal number of x, y co-ordinates required');
numPoints = length(x);

% create vector of 50 y points from upper to lower surfaces at each x point
y = zeros(NUM_POINTS, length(x)); 

for i = 1:length(x)
    y(:, i) = linspace(yUpper(i), yLower(i), NUM_POINTS)';
end

%% FIND MAXIMUM AREA
% find the maximum rectangle in the created grid of points
[A, xLimits, yLimits] = possibleAreasUnderCurve(x, y)

createRect( A, xLimits, yLimits, x, yUpper, x, yLower, 'Brute Force Approach');

