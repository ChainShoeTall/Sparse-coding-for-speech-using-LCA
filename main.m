% Sparse coding of monoral sound by LCA
CLEAR_ALL = 1;
if CLEAR_ALL, clear all; clc; end
% Read sound file and get log spectrogram
addpath(genpath('.'));

filePath = 'C:\Users\schenbq\Downloads\PDA\PDA\PDAm\16k\*\*_5.wav';

soundfiles = dir(filePath);

% [soundfiles, nFiles] = rm_shortfile(soundfiles); % Remove files less than
% fft length, which is too short.
% nFilesPerBatch = 20;
% nBatches = floor(nFiles/nFilesPerBatch);
%=========================================================================%
% Segmentation and spectrogram parameters
fs = 16000;
nPerSeg = 4096*4;
winLen = 600;
nAdvance = 100;
[sCombined, fs, f, tAll] = make_multi_spec(soundfiles, 1,30, nAdvance, winLen, nPerSeg, false);
[sCombinedLog,f] = sample_logspec(sCombined,f);

% Learning Paremeters
itersUpdateS = 5; % # of iteratoins per s/A update
itersUpdateA = 80;
nNeurons = 150; % # of neurons
lamb = 0.5; % sparsity constraints weight
tau = 0.1; % learning rate for s update
eta = 0.1; % learning rate for A update
theta = 0.001; % orthogonalizing component
nReps = 10;


%=========================================================================%
nPC = 200; % # of rinciple components
% Segmentation parameters
segmentLenMS = 216;
segmentLen = floor(segmentLenMS/1000/nAdvance*fs); % # of segment samples
segmentStep = floor(segmentLen/10); % shifting step for each segment
% dt = segmentLen*nAdvance/fs*1000; % length of each window in ms
[segmentWidth,lenSpecCombined] = size(sCombinedLog);

segmentListInd = 1;
nSegments = floor((lenSpecCombined-segmentLen)/segmentStep);
segmentList = zeros(segmentLen*segmentWidth, nSegments);
segmentList2 = zeros(segmentLen*segmentWidth, nSegments);
for iSeg = 1:nSegments
    fprintf("Segment Number: %d\n", iSeg);
    segmentList(:,iSeg) = reshape(sCombinedLog(:,...
        (iSeg-1)*segmentStep+1:(iSeg-1)*segmentStep+segmentLen),[],1);
end

mp = MyPCA;
Y = mp.compute_trans(segmentList,nPC);

% Initialize and normalize A
rng(2);
A = rand(nPC, nNeurons); % should compare 'randn' or 'rand'
A = normalize_col(A);
bestCosts = inf;
bestCostA = inf;
prevCosts = inf;
prevCostA = inf;
etaOri = eta;

costA = inf;
costs = inf;
% nReps = 1;
for iRep = 1:nReps
    fprintf("===== Updating s iteration: %d\n", iRep);
    [s, costs] = find_s_batch(tau, A, Y, lamb, itersUpdateS, 'paper', false);
    fprintf("===== Updating A iteration: %d\n", iRep);
    try
        [A, costA] = do_multiple_learn_steps(Y,A,s,eta,theta,itersUpdateA,lamb,false);
    catch
        eta = eta*0.1;
    end
    A = normalize_col(A);
    
    tau = tau*1.0;
    eta = eta*1.0;
    theta = theta*1.0;
    
    fprintf("Tau=%f, eta=%f, theta=%f\n", tau, eta, theta);
    prevCostA = costA;
    prevCosts = costs;
    if (iRep > 0)&&(costA < bestCostA)
        bestCostA = costA;
        bestCosts = costs;
        bests = s;
        bestA = A;
    end
end
[bests, bestCosts] = find_s_batch(tau, bestA, Y, lamb, itersUpdateS, 'paper',true);

nSamples = size(Y,2);
reconA = mp.inver_trans(bestA);
plot_grid_images(reconA,256,34,10,15,100,f);

    
    
    
    