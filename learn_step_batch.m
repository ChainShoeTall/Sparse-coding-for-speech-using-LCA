function newA = learn_step_batch(Y,A,S,eta,theta)
R = Y - A*S;
newA = A + eta*(R*S') + theta*(A-(A*(A'*A)));
end