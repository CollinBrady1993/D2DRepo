function[fk] = probOfKCaptures(Nu,Nd,theta,Nr,Nt,gamma,alpha,macCol)
%this is the round >1 calculation

%% initialization
fk = zeros(1,min(Nu-Nd,Nr+1));
fk1 = zeros(1,min(Nu-Nd,Nr+1));

%% grabbing the colision probabilities and A data
colProbLookup = csvread('collisionDataNew.csv');
pCol = ones(Nu-Nd,Nd+1);%the rows represent Na, and the columns Nb
for i = 1:size(pCol,1)-1
    for j = 1:size(pCol,2)%the reason Nb ranges from 0:Nu while Na ranges 1:Nu is that if Na = 0 Pdisk(k) = 0 for all k
        pCol(i+1,j) = tableLookup(colProbLookup,[i,j-1,gamma,alpha]);
    end
end

if macCol == 1
    pCol = ceil(pCol);%makes all multi-occupancy prb collisions, akin to mac collisions
end

A = cell(Nu-1,Nd+1,min(Nu-1,Nr));%why is this written in a wierd way? well there are 
%potentially Nu-1 undiscovered UE that can transmit, so thats why Nu(0:Nu-1). The
%reason that we have Nd+1+1 is that because Nd can be 0 we need a +1 for
%size purposes, basically we need there to always be at least 1 there, the
%other +1 represents the reference UE, which cant discover itself but still
%play discovery(0:Nd+1).
for i = 1:(Nu)
    for j = 0:min(i-1,Nd+1)
        for k = 1:min(i,min(Nu,Nr))
            string = strcat('AData/Nu',num2str(i),',Np',num2str(j),',r',num2str(k),'.csv');
            A{i,j+1,k} = csvread(string);
        end
    end
end


%% the actual calculation
for Na = 0:Nu-Nd-1%number of undiscovered UE which transmit
    PNa = binopdf(Nu-Nd-1,Na,theta);%(factorial(Nu-Nd-1)/(factorial(Na)*factorial(Nu-Nd-1-Na)))*(theta^Na)*((1 - theta)^(Nu-Nd-1-Na));
    if PNa > 0
        for Nb = 0:Nd%number of discovered UE which transmit
            PNb = binopdf(Nd,Nb,theta);%(factorial(Nd)/(factorial(Nb)*factorial(Nd-Nb)))*(theta^Nb)*((1 - theta)^(Nd-Nb));
            if PNb > 0
                fk2 = zeros(1,min(Nu-Nd,Nr+1));
                for Nad = 0:Na%number of transmitting UE which experience duplex
                    
                    PNad = binopdf(Nad,Na,1/Nt);%(factorial(Na)/(factorial(Nad)*factorial(Na-Nad)))*((1/Nt)^Nad)*((1 - 1/Nt)^(Na-Nad));
                    
                    if Nad < Na
                        for Nbd = 0:Nb
                            
                            PNbd = binopdf(Nbd,Nb,1/Nt);%(factorial(Nb)/(factorial(Nbd)*factorial(Nb-Nbd)))*((1/Nt)^Nbd)*((1 - 1/Nt)^(Nb-Nbd));
                            fkTemp = PDiscovery2(Na-Nad,Nb-Nbd,Nr-(Nr/Nt),pCol,A(Na + Nb - Nad - Nbd,Nb - Nbd + 1,:));%%%%%%change
                            fkTemp = [fkTemp,zeros(1,min(Nu-Nd,Nr+1)-length(fkTemp))];
                            fk2 = fk2 + PNad*PNbd*fkTemp;
                        end
                    elseif Nad == Na
                        for Nbd = 0:Nb
                            
                            PNbd = binopdf(Nbd,Nb,1/Nt);%(factorial(Nb)/(factorial(Nbd)*factorial(Nb-Nbd)))*((1/Nt)^Nbd)*((1 - 1/Nt)^(Nb-Nbd));
                            fkTemp = 1;
                            fkTemp = [fkTemp,zeros(1,min(Nu-Nd,Nr+1)-length(fkTemp))];
                            fk2 = fk2 + PNad*PNbd*fkTemp;
                        end
                    end
                end
                
                if Na > 0
                    fk1 = PDiscovery2(Na,Nb,Nr,pCol,A(Na+Nb,Nb+1,:));
                    fk1 = [fk1,zeros(1,min(Nu-Nd,Nr+1)-length(fk1))];
                    fk = fk + PNa*PNb*(theta*fk2 + (1-theta)*fk1);
                else
                    fk1 = 1;
                    fk1 = [fk1,zeros(1,min(Nu-Nd,Nr+1)-length(fk1))];
                    fk = fk + PNa*PNb*(theta*fk2 + (1-theta)*fk1);
                end
                
                
            end
        end
    end
end
end


