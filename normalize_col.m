function newA = normalize_col(A)
[~,n] = size(A);
newA = zeros(size(A));
for iCol = 1:n
    newA(:,iCol) = A(:,iCol)/norm(A(:,iCol));
end
end