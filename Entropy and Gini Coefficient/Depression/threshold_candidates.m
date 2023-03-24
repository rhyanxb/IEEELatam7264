function th_cand = threshold_candidates(x,y)
% Calculate the threshold candidates based on the samples with opposite tags
% Input:
% x: attributes
% y: binary signal with the tags
% Output:
% th_cand:threshold candidates

% Sort x 
[xs,ind] = sort(x);

% Tags of the sorted attributes
ys = y(ind);

% Indices of the samples with opposite tags
ind_opp = find((ys(2:end) - ys(1:end-1)) ~= 0);

% Threshold candidates with repetition
th_cand_rep = (xs(ind_opp) + xs(ind_opp + 1))/2;
th_cand_rep = th_cand_rep(find( (th_cand_rep ~= min(xs)) & (th_cand_rep ~= max(xs)) ));

% Eliminate repeated values
th_cand = unique(th_cand_rep);

% Test if th_cand is empty
if length(th_cand) == 0
    th_cand = min(x);
end
end