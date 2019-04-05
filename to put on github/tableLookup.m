function [out] = tableLookup(lookupTable,entry)
%the goal is to serve as a more generalized table lookup function, assume
%that lookupTable has length(lookupTable)-1 colunms of identifying data and
%1 column of data. the values in entry are assumed to be sorted in the same
%order as their coresponding identiying data in the table, i.e. if the
%table is [val1,val2,val3,data] the entry is [val1,val2,val3].

n = length(entry);
currentLookup = {1:size(lookupTable,1)};

for i = 1:n
    k = 1;
    for j = 1:size(currentLookup,1)
        temp = currentLookup{j}(round(lookupTable(currentLookup{j},i),4) == round(entry(i),4));%rounding helps with tolerances
        if isempty(temp)
            u = unique(lookupTable(:,i));
            
            A = u - entry(i);
            [I] = min(A(A > 0));
            upper = u(A == I);
        
            [I] = max(A(A < 0));
            lower = u(A == I);
            
            nextLookup{k,1} = currentLookup{j}(round(lookupTable(currentLookup{j},i),4) == upper);
            nextLookup{k+1,1} = currentLookup{j}(round(lookupTable(currentLookup{j},i),4) == lower);
            k = k+2;
        else
            nextLookup{k,1} = temp;
            k = k+1;
        end
    end
    currentLookup = nextLookup;
end

currentLookup = cell2mat(currentLookup);

if log2(length(currentLookup)) == 0
    out = lookupTable(currentLookup,5);
else
    currentOut = lookupTable(currentLookup,5);
    for i = 1:log2(length(currentLookup))
        for j = 1:2:length(currentOut)
            
            index = abs(round(lookupTable(currentLookup(j),1:4),4) - round(lookupTable(currentLookup(j+1),1:4),4)) > 0;
            x = [lookupTable(currentLookup(j),index),lookupTable(currentLookup(j+1),index)];
            v = [lookupTable(currentLookup(j),5),lookupTable(currentLookup(j+1),5)];
            xq = entry(index);
            nextOut((j+1)/2,1) = interp1(x,v,xq);
        end
        currentLookup = currentLookup(1:2:end);
        currentOut = nextOut;
        nextOut = [];
    end
    out = currentOut;
end


end

