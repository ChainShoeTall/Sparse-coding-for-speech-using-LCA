function disp_spec(s,f,t,nfig)
% display spectrogram
[m,n] = size(f);
if nargin < 4, nfig=999; end
if m<n, f=f'; end

figure(nfig);
imagesc(t,f,s);
colormap jet
set(gca,'YDir','normal');
end