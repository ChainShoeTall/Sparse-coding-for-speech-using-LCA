function [bestS, bestCost] = find_s_batch(tau, A, Y, lamb, nIters, update, verbose)
if nargin < 5
    nIters = 100;
end
if nargin < 6
    update = 'paper';
end
if nargin < 7
    verbose = false;
end

bestCost = inf;
prevCost = inf;

[~, nNeurons] = size(A);
nObs = size(Y,2);
S = zeros(nNeurons, nObs);
bestS =  zeros(nNeurons, nObs);
U = zeros(nNeurons, nObs); % internal state

for iIter = 1:nIters
    if strcmp(update,'direct')
        ds = A'*Y - A'*A*S - sign(S);
        S = S + ds * tau;
    elseif strcmp(update, 'paper')
        du = A'*Y - A'*A*S - sign(S);
        U = U + du * tau;
        S = T(U, lamb, 'L1'); % S is int??????
%         disp(max(max(S)));
    end
    diff = reshape((Y - A*S),[],1);
    cost = 0.5*norm(diff)^2+lamb*(norm(reshape(S,[],1),1));
    
    if cost <= prevCost
        tau = tau*1.05;
    else
        tau = tau*0.5;
    end
    prevCost = cost;
    
    if cost < bestCost
        bestCost = cost;
        bestS = S;
    end
    
    if verbose
        fprintf("Cost = %f, tau = %f\n",cost, tau);
    end
% to be done ...
end
fprintf("Best cost is %f\n", bestCost);
end


