% Function that find the largest axis-aligned (i.e. not rotated) rectangle
% in a grid of points representing a shape (such as an airfoil)
% Author: Declan Walsh
% Last Modified: 8/8/2016

% ARGUMENTS
% x = x points in grid (1xn)
% yUpper/yLower = y points in grid (1xn) at each x co-ordinate on the the upper and lower surfaces
% xBounds = 2x1 array with front and rear spacing required from the curve

% RETURNS
% AMax = maximum area (in units of input co-ordinates)
% xLimits = [xLE, xTE] = 1x2 vector of the leading and trailing x co-ordinates of the maximum rectangle
% yLimits = [yTop, yBot] = 1x2 vector of the leading and trailing y co-ordinates of maximum rectangle
% ID = integer for debug containing type of rectangle the gave solution

function [ AMax, xLimits, yLimits, ID] = possibleAreasUnderCurveAlgo( x, yUpper ,yLower, xBounds, tWall)

% setting output variables initial values
AMax = 0;
yLimits = [0,0];
xLimits = [0,0];
ID = 0;

MAX_Y_UPPER = max(yUpper); % program stopped after the peak is reached (no boxes can fit after it)
MAX_X = max(x);

idxLeading = find(x > xBounds(1), 1, 'first'); % start at point after LE gap
idxTrailing = find(x < MAX_X - xBounds(2), 1, 'last'); % stop at point before TE gap

% GENERAL ALGORITHIM IS:
% i) set LE x co-ordinate
% ii) setup the four possible corners from the x co-ordinate (TR, TL, BR, BL)
% iii) largest rectangle must have 3 corners on surface and the four options for each x co-ordinate are checked 
% iv) if rectangle lies fully in shape calculate area and compare to max
% v) move to next LE x co-ordinate up to maximum thickness point (no rectangles exist after)

while(yUpper(idxLeading) < MAX_Y_UPPER)
    xLeading = x(idxLeading);
    yUpperLeading = yUpper(idxLeading);
    yLowerLeading = yLower(idxLeading);
    
    % finds the other corner of the rectangle for a convex shape by
    % checking for the bottom right corner
    idxLowerTrailing = find(yLower<=yLower(idxLeading), 1, 'last');
    
    % if the point lies beyond the trailing edge gap (e.g. all points are
    % on the same minimum) sets it as the top right corner
    if(idxLowerTrailing > idxTrailing)
        idxLowerTrailing = find(yUpper>yUpperLeading, 1, 'last');
    end
    
    % if there is still no solution (e.g. both top and bottom lines are 
    % coincident) skips the point
    if(isempty(idxLowerTrailing))
        idxLeading = idxLeading + 1;
        continue
    end
    
    if(idxLeading == 149)
           disp('HERE') 
    end
    
    yLowerTrailing = yLower(idxLowerTrailing + 1);
    yLowerUpperTrailing = yUpper(idxLowerTrailing + 1);
    xLowerTrailing = x(idxLowerTrailing + 1);
    
    % finds the other corner of the rectangle for a convex shape by
    % checking for the top right corner
    idxUpperTrailing = find(yUpper>yUpper(idxLeading), 1, 'last');
    
    yUpperTrailing = yUpper(idxUpperTrailing + 1);
    yUpperLowerTrailing = yLower(idxUpperTrailing + 1);
    xUpperTrailing = x(idxUpperTrailing + 1);
    
    % four cases to check for four corners each free
    % case i (Top Right free)
    if(yLowerUpperTrailing < yUpperTrailing)
        area = (xLowerTrailing - xLeading - 2*tWall) * (yLowerUpperTrailing - yLowerTrailing - 2*tWall);
        [AMax, xLimits, yLimits, ID] = checkArea(area, AMax, xLeading, xLowerTrailing, yLowerUpperTrailing, yLowerTrailing, xLimits, yLimits, ID, 1);
    end
        
    % case ii (Bottom Right free)
    if(yUpperLowerTrailing > yLowerTrailing)
        area = (xUpperTrailing - xLeading - 2*tWall) * (yUpperTrailing - yUpperLowerTrailing - 2*tWall);
        [AMax, xLimits, yLimits, ID] = checkArea(area, AMax, xLeading, xUpperTrailing, yUpperTrailing, yUpperLowerTrailing, xLimits, yLimits, ID, 2);
    end
        
    % case iii (Top Left Free)
    if(yLowerUpperTrailing < yUpperLeading)
        area = (xUpperTrailing - xLeading - 2*tWall) * (yUpperTrailing - yLowerLeading - 2*tWall);
        [AMax, xLimits, yLimits, ID] = checkArea(area, AMax, xLeading, xUpperTrailing, yUpperTrailing, yLowerLeading, xLimits, yLimits, ID, 3);
    end
        
    % case iv (Bottom Left free)
    if(yUpperLowerTrailing > yLowerLeading)
        area = (xLowerTrailing - xLeading - 2*tWall) * (yUpperLeading - yLowerTrailing - 2*tWall);
        [AMax, xLimits, yLimits, ID] = checkArea(area, AMax, xLeading, xLowerTrailing, yUpperLeading, yLowerTrailing, xLimits, yLimits, ID, 4);
    end
    
    idxLeading = idxLeading + 1;
    
end

    
      
end