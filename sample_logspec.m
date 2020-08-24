function [logSpec, freqs]=sample_logspec(s, f, nSamples, fmin, fmax)
if nargin < 3, nSamples = 256; end
if nargin < 4, fmin = 100.0; end
if nargin < 5, fmax = 4000.0; end
logFreqs = linspace(log(fmin), log(fmax), nSamples);
freqs = exp(logFreqs);
rowIds = zeros(nSamples, 1);
for iSample = 1:nSamples
    rowIds(iSample,1) = length(f(f<freqs(iSample)));
end
logSpec = s(rowIds,:);
end