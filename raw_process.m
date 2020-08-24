function [yProcessed, newFs] = raw_process(y, fs, mode)
if nargin < 3, mode = 99; end
switch mode
    case 1
        yProcessed  = y(find(y,1,'first'):find(y,1,'last')); % Trim zeros before and after
        newFs = 16e3;
        yProcessed = resample(yProcessed, newFs, fs);
    case 2
        newFs = 16e3;
        yProcessed = resample(y, newFs, fs);
    case 99
        newFs = fs;
        yProcessed = y;
end
end