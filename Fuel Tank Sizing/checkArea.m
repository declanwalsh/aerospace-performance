function [ A_MAX, X_LIM, Y_LIM, ID ] = checkArea( area, areaMax, x1, x2, y1, y2, xLimits, yLimits, idOld, idNew)

    if (area > areaMax)
        A_MAX = area;
        X_LIM = [x1, x2];
        Y_LIM = [y1, y2];
        ID = idOld;
    else
        A_MAX = areaMax;
        X_LIM = xLimits;
        Y_LIM = yLimits;
        ID = idNew;
    end

end

