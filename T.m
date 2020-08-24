function s = T(u, lamb, norm_type)
% Threshold function with appropriate norm type L0 or L1;
% NEED to use bsxfun intead of for loop ??????
if nargin < 3, norm_type = 'L1'; end
if strcmp(norm_type, 'L0')
    s = bsxfun(@max, u, 0);
elseif strcmp(norm_type, 'L1')
    [m,n] = size(u);
    s = zeros(size(u));
    for iM = 1:m
        for iN = 1:n
            if u(iM,iN) > lamb
                s(iM,iN) = u(iM,iN)-lamb;
            elseif u(iM,iN) < -lamb
                s(iM,iN) = u(iM,iN)+lamb;
            else
                s(iM,iN) = 0;
            end
        end
    end
else
    error("Norm type can only be L0 or L1");
end
        
    