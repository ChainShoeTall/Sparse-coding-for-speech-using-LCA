function newA = learn_step(y,A,s,eta,theta)
r = y - A*s;
newA = A + eta*(r*s') + theta*(A-A*(A'*A));
end