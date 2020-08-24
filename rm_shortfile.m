function [soundfiles, nFiles] = rm_shortfile(soundfiles, sampleThresh)
if nargin < 2
    sampleThresh = 4096*4;
end
nFiles = length(soundfiles);
for iFile = nFiles:-1:1
    fileInformation = audioinfo(fullfile(soundfiles(iFile).folder, soundfiles(iFile).name));
    if fileInformation.TotalSamples < sampleThresh
        soundfiles(iFile) = [];
    end
end
nFiles = length(soundfiles);
end