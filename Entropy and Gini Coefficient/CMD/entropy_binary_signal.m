function H = entropy_binary_signal(x)
% Canculate the entropy of a binary signal composed of 0's and 1's
% Input:
% x: binary signal c
% Output:
% H: entropy

if length(x) == 0 
    H = 0;
else
    p0 = length(find(x==0))/length(x);
    p1 = 1 - p0;%length(find(x==1))/length(x);
	if p0 == 0
        H = - p1*log2(p1);
    elseif p1 == 0
        H = - p0*log2(p0);
    else
        H = -p0*log2(p0) - p1*log2(p1);
    end
end

end