function [rmMean,matMean] = sub_row_mean(mat)
matMean = mean(mat,2);
[~,m] = size(mat);
rmMean = mat-repmat(matMean,1,m);
end