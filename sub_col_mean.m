function rmMean = sub_col_mean(mat)
matMean = mean(mat,1);
[m,~] = size(mat);
rmMean = mat-repmat(matMean,m,1);
end