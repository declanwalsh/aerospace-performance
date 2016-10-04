function [X, Y] = fcnlineoff(x, y, offset)

    % find slope
    m = diff(x + 1i*y);
    % use average of slope on each side
    % better result for large spaces between points
    m = [m(1) (m(1:(end-1)) + m(2:end))/2 m(end)];
    
    % calculate offset
    vOff = offset*m*exp(-1i*pi/2) ./ abs(m);
    
    % generate ouput vectors
    X = [x-real(vOff), fliplr(x+real(vOff))];
    Y = [y-imag(vOff), fliplr(y+imag(vOff))];

    % use to plot the normals
% X = [x+real(vOff); x; x-real(vOff)];
% Y = [y+imag(vOff); y; y-imag(vOff)];
end