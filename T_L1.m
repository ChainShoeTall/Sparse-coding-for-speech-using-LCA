function s = T_L1(u, lamb)
% Threshold function with appropriate norm type 'L1';
if bsxfun(@gt,u,lamb)
    s = bsxfun(@minus,u, lamb);
elseif bsxfun(@lt, u, -lamb)
    s = bsxfun(@plus, u, lamb);
else
    s = bsxfun(@times, u, 0);
end
    