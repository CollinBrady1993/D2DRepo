function [J] = makeJ(A,N)

J = zeros(size(A,1),N);

for i = 1:size(J,1)
    for j = 1:N
        J(i,j) = sum(A(i,:) == j);
    end
end

end

