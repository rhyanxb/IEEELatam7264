function G = gini_binary_signal(x)
% Canculate the Gini diversity index of a binary signal composed of 0's and 1's
% Input:
% x: binary signal 
% Output:
% G: Gini diversity index

if length(x) == 0 
    G = 0;
else
    p0 = length(find(x==0))/length(x);
    G = 2*p0*(1 - p0); 

end

end