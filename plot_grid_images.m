function plot_grid_images(data, rowEach, colEach, rowNum, colNum, figNo,f)
assert(size(data,1)==rowEach*colEach,'Invalid row and col for each image\n');
if nargin < 6, figNo = 99; end
figure(figNo);
t = linspace(1,colEach,colEach);
load mycm.mat
for i=1:size(data,2)
    subplot(rowNum, colNum, i);
    if i==(rowNum-1)*colNum+1
        imagesc(t,f,reshape(data(:,i),rowEach,colEach));
%         imagesc(t,f,reshape(data(:,i),colEach,rowEach)');
        axis on
        xlabel('frame');
        ylabel('frequency(Hz)');
        
    else
%         imagesc(reshape(data(:,i),colEach,rowEach)');
        imagesc(t,f,reshape(data(:,i),rowEach,colEach));
        axis off
    end
    colormap(mycm);
    axis xy;
end
end