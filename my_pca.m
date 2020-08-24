function u = my_pca(X, nPC, doWhiten)
% X[nDim, nSamples]
if nargin < 3, doWhiten = true; end
    X = X';
    m = size(X,1);
    muX = mean(X);
    if doWhiten
        stdX = std(X);
        X = (X - repmat(muX,m,1))./repmat(stdX,m,1);
    else
        X = (X - repmat(muX,m,1));
    end
    corrX = corrcoef(X);
    [V, ~] = eig(corrX);
    V = rot90((V))';
    u = V(:,1:nPC);
end