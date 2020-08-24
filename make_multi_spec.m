function [sCombined, fs, f, tAll] = make_multi_spec(fileInfo, fileStart,fileEnd, nAdvance, winLen, nPerSeg,doLogSpec)
if nargin < 7, doLogSpec = true; end
if ischar(fileInfo)
    soundfiles = dir(fileInfo);
    soundfiles = soundfiles(fileStart:fileEnd);
    [soundfiles,~] = rm_shortfile(soundfiles);
elseif isstruct(fileInfo)
    soundfiles = fileInfo(fileStart:fileEnd);
else
    error("Unrecoginized file information");
end
tAll = [];
sCombined = [];
thead = 0;
nCombineFiles = length(soundfiles);
for iCombineFile = 1:nCombineFiles
    [y,fs] = audioread(fullfile(soundfiles(iCombineFile).folder,soundfiles(iCombineFile).name));
    fprintf("Processing file %d of %d, fs=%d\n", iCombineFile, nCombineFiles, fs);
    [yTrim, fs] = raw_process(y, fs);
    if doLogSpec
        [s,f,t] = direct_logspec(yTrim, fs, nAdvance, winLen);
    else
        [s,f,t] = multitaper_spec(yTrim, fs, nAdvance, winLen, nPerSeg);
    end    
    t = t+thead;
    tAll = [tAll,t];
    sCombined = [sCombined, s];
    thead = thead + length(yTrim)*1.0/fs;
end 
end