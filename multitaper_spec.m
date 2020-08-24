function [s, f, t, ps] = multitaper_spec(X, fs, nAdvance, winLen, nPerSeg)
% Use blackman window first
% nPerSeg is padding zeros for nfft
if nargin < 3, nAdvance = 100; end
if nargin < 4, winLen = 500; end
if nargin < 5, nPerSeg = 4*4096; end

window = blackman(winLen);
window = [window; zeros(nPerSeg-winLen, 1)];
nOverlap = nPerSeg-nAdvance;
nfft = nPerSeg;
% nfft = linspace(1,fs/2,nPerSeg);
[s, f, t, ps] = spectrogram(X, window, nOverlap, nfft, fs);
% s = 20*log10(abs(s));
s = 20*log10(ps*32767.0*32767.0);
end