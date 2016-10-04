function [ ax ] = createRect(A, xLimits, yLimits, xUp, yUp, xLow, yLow, str, xUpTrue, yUpTrue, xLowTrue, yLowTrue)

    % convert the results into rectangle format for Matlab
    widthRect = xLimits(2) - xLimits(1);
    heightRect = yLimits(1) - yLimits(2);
    xRect = xLimits(1);
    yRect = yLimits(2);
    titleStr = strcat('Max Rect -', str, sprintf(' - %.4f m2', A));
    
    %% PLOT RESULTS
    % plot the airfoil and the determined maximum rectangle
    ax = figure;
    hold on;
    axis equal
    plot(xUp, yUp, 'b-');
    plot(xLow, yLow, 'b-');
    rectangle('Position', [xRect, yRect, widthRect, heightRect], 'FaceColor', [0, 0, 0]);
    xlabel('X (absolute from leading edge) (m)')
    ylabel('Y (absolute from leading chord) (m)')
    title(titleStr);
    
    if(nargin > 9)
        plot(xUpTrue, yUpTrue, 'r-');
        plot(xLowTrue, yLowTrue, 'r-');
    end

end

