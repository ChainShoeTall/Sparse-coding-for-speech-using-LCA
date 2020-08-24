function [logS,logF,t] = direct_logspec(X, fs, nAdvance, winLen,lowF,highF,nchans)
if nargin < 3, nAdvance=100; end
if nargin < 4, winLen = 500; end
if nargin < 5, lowF = 100; highF = 4000; end
if nargin < 7, nchans = 256; end

nOverlap = winLen-nAdvance;
logF = logspace(log10(lowF),log10(highF),nchans);
[logS, logF, t] = spectrogram(X,blackman(winLen),nOverlap,logF,fs);
logS = 20*log10(abs(logS)+eps);
end