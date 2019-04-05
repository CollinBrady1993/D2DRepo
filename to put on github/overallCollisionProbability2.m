function [prob] = overallCollisionProbability2(B2,C,A,pCol)
%this function computes the overall collision probaility based on the
%number of collisions and no collisions, along with the number of coTx,
%gamma and alpha

q = factorial(B2)/(factorial(C)*factorial(B2-C));
prob = 0;
index = zeros(q,B2);
index(1,:) = [ones(1,C),zeros(1,B2-C)];
colProb = zeros(1,length(A));
for i = 1:length(A)
    colProb(i) = pCol(real(A(i)+1),imag(A(i))+1);
end

for i = 2:q
    index(i,:) =shiftIndex(index(i-1,:),1);
end

parfor i = 1:q%for each possible set of coTx for both collisions and not collisions
    
    PC = prod(1-colProb(logical(index(i,:))));
    PnotC = prod(colProb(not(logical(index(i,:)))));
    
    prob = prob + PC*PnotC;%total probability is formed of the sum of the probabilities of each indivisual set of coTx
    
end
end

