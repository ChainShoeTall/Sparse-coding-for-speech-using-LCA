CLEAR_ALL = 1;
if CLEAR_ALL, clear all; clc; end
% Read sound file and get log spectrogram
addpath(genpath('.'));
filePath = '..\Audio-Sparse-Coding\data\train\*.wav';
soundfiles = dir(filePath);
nFiles = length(soundfiles);

%=========================================================================%
%%%%%% For multiple learning stages %%%%%%
nPC = 200; % # of rinciple components
nFilesPerBatch = 20;
nBatches = floor(nFiles/nFilesPerBatch);

%%%%%% Learning parameters %%%%%%
itersUpdateS = 100; % # of iteratoins per s/A update
itersUpdateA = 100;
nNeurons = 100; % # of neurons
lamb = 0.5; % sparsity constraints weight
tau = 0.1; % learning rate for s update
eta = 0.1; % learning rate for A update
theta = 0.001; % orthogonalizing component
nReps = 20;

%%%%%% Initialize and normalize A %%%%%%
rng(2);
A = rand(nPC, nNeurons); % should compare 'randn' or 'rand'
A = normalize_col(A);
% A = sub_col_mean(A);
bestCosts = inf;
bestCostA = inf;
prevCosts = inf;
prevCostA = inf;
etaOri = eta;

%%%%%% Spectrogram parameters %%%%%%
fs = 16e3;
nAdvance = 100; % Shift for window
nPerSeg = 4096*4; % for nfft, only for multitaper_spec
winLen = 500;

%%%%%% Segment to overlapping segments %%%%%%
segmentLenMS = 216;
segmentLen = int16(segmentLenMS/1000/nAdvance*fs); % # of segment samples
segmentStep = int16(segmentLen/10); % shifting step for each segment
% dt = segmentLen * nAdavnce/fs*1000;

%=========================================================================%
% nBatches = 1;
iBatch = 2;
for iBatch = 1:nBatches
    fprintf("Iteration: %d\n",iBatch);
    fStart = (iBatch-1)*nFilesPerBatch+1;
    fEnd = iBatch*nFilesPerBatch;
    [sCombined, fs, f, tAll] = make_multi_spec(soundfiles, fStart, fEnd, nAdvance, winLen, nPerSeg, true);
    [segmentWidth, lenSpecCombined] = size(sCombined);
    segmentStep = int16(segmentLen/5);
%     nSegments = floor(lenSpecCombined-segmentLen)/segmentStep+1;
    dt = segmentLen*nAdvance/fs*1000;
    segmentList = [];
    segmentListInd = 1;
    for iSeg = 1:segmentStep:lenSpecCombined-segmentLen
        segmentTemp = reshape(sCombined(:,iSeg:iSeg+segmentLen-1),[],1);
        segmentList = [segmentList, segmentTemp];
    end
    nSegments = size(segmentList, 2);
    
    % Perform PCA
    fprintf("Segment Number: %d, Applying PCA\n",nSegments);
    segmentList = sub_row_mean(segmentList);
    pcaSpec = my_pca(segmentList, nPC, true); % may take some time, will try EM-PCA
    Y = pcaSpec'*segmentList;
%     for iRep = 1:nReps
    for iRep = 1:nReps
        [s, costs] = find_s_batch(tau, A, Y, lamb, itersUpdateS, 'paper', false);
        [A, costA] = do_multiple_learn_steps(Y,A,s,eta,theta,itersUpdateA,lamb,false);
        A = normalize_col(A);
        fprintf("Tau=%f, eta=%f, theta=%f\n", tau, eta, theta);
        prevCostA = costA;
        prevCosts = costs;
        if (iBatch > 0)&&(costA < bestCostA)
            bestCostA = costA;
            bestCosts = costs;
            bests = s;
            bestA = A;
        end
    end
end
    
% [sCombined, fs, f, tAll] = make_multi_spec(soundfiles, 181,181,nAdvance, winLen, nPerSeg, true);
% disp_spec(sCombined, f, tAll, 101);