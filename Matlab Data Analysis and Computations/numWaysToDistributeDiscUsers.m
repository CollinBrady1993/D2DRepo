function [out] = numWaysToDistributeDiscUsers(AR,AI,Nu)
out = 1;
for j = 0:Nu
    if sum(AI(AR==j)) > 0%there actually has to be something in there
        out = out*factorial(length(AI(AR==j)))/prod(factorial([sum(AI(AR==j)==0),makeJ(AI(AR==j),Nu)]));
    end
end

end