function [y, fs] = read_audio(filePath, fileInd, rawFlag)
if nargin < 3; rawFlag = true; end
soundfiles = dir(filePath);
[y, fs] = audioread(fullfile(soundfiles(fileInd).folder, soundfiles(fileInd).name));
if rawFlag, [y, fs] = raw_process(y, fs); end
end