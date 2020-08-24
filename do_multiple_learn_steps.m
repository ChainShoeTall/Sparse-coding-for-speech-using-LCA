function [bestA, bestCost] = do_multiple_learn_steps(y,A,s,eta,theta,nSteps,lamb,verbose)

diff = reshape((y-A*s),[],1);
cost = 0.5*norm(diff)^2+lamb*norm(reshape(s,[],1),1);
prevCost = cost;
bestCost = cost;
bestA = A;

for istep = 1:nSteps
    if size(y,2) == 1
        A = learn_step(y,A,s,eta,theta);
    else
        assert(size(y,2)==size(s,2));
        A = learn_step_batch(y,A,s,eta,theta);
        A = normalize_col(A);
        diff = reshape((y-A*s),[],1);
        cost = 0.5*norm(diff)^2+lamb*norm(reshape(s,[],1),1);
    end
    
    if verbose
        fprintf("Cost=%f, eta=%f, theta=%f\n", cost, eta, theta);
    end
    if cost < bestCost
        bestCost = cost;
        bestA = A;
    end
    if cost <= prevCost
        eta = eta*1.05;
        theta = theta*1.05;
    else
        eta = eta*0.5;
        theta = theta*0.5;
    end
    prevCost = cost;
end
fprintf("Best cost =%f\n", bestCost);
end
    