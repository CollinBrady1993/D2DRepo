function [fk] = PDiscovery2(Na,Nb,Nr,pCol,a)
%this is the Pdisc for the case where Na UE have not been discovered, Nb
%have been and Nu = Na + Nb are transmitting this round.

fk = zeros(1,min(Na+1,Nr+1));

%% a catch for if no one transmits
if Na == 0
    fk = 1;
    return
end

%% clculate Fk
prob = (1/Nr)^(Na)*(1/Nr)^(Nb);
for r = 1:min(Nr,Na+Nb)
    r;
    %datestr(now)
    
    %string = strcat('AData/Nu',num2str(Na+Nb),',Np',num2str(Nb),',r',num2str(r),'.csv');
    A = a{:,:,r};%csvread(string);%finds all partitions of Nu-1, given r bins are used
    AR = real(A);
    AI = imag(A);
    JR = makeJ(AR,Na+Nb);
    
    for i = 1:size(A,1)
        num = (factorial(Nr)/(factorial(r)*factorial(Nr-r)))*factorial(Na)/prod(factorial(AR(i,:)))*factorial(Nb)/prod(factorial(AI(i,:)))*(factorial(r)/(factorial(length(AR(i,AR(i,:)>0)))*factorial(r - length(AR(i,AR(i,:)>0)))))*(factorial(length(AR(i,AR(i,:)>0)))/prod(factorial(JR(i,:))))*numWaysToDistributeDiscUsers(AR(i,:),AI(i,:),Na+Nb);
        for k = sum(A(i,:)==1):sum(JR(i,:))%the number of discoveries cant be less than the number of ones, and cant be more than the number of PRB occupied by undiscovered UE
            
            colProb = overallCollisionProbability2(sum(JR(i,:))-sum(A(i,:)==1),k-sum(A(i,:)==1),A(i,(AR(i,:)>1) | (AR(i,:)>0) & (AI(i,:)>0)),pCol);
            fk(k+1) = fk(k+1) + num*prob*colProb;
        end
    end
end
end