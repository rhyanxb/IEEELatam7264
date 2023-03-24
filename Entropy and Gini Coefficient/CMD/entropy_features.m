clc
clear all
close all

% Load database
load basenovatmcsemSQR20 basenovatmcsemSQR20
X = basenovatmcsemSQR20(:,1:end-1);
y = basenovatmcsemSQR20(:,end);
clear basenovatmcsemSQR20
[N M] = size(X); % N: number of samples, M: number of features

% Entropy of the original databese
H0 = entropy_binary_signal(y);

% Loop for the features
for mm = 1:M
    
    % Threshold candidates for the division of the data
    th_cand = threshold_candidates(X(:,mm),y);
    
    % Calculating the entropy of the divided data using the threshold candidates
    clear H_th
    for tt = 1:length(th_cand)
        H_higher = entropy_binary_signal(y(find(X(:,mm) > th_cand(tt))));
        H_lower = entropy_binary_signal(y(find(X(:,mm) <= th_cand(tt))));
        H_th(tt) = (length(y(find(X(:,mm)>th_cand(tt))))*H_higher + length(y(find(X(:,mm)<=th_cand(tt))))*H_lower)/N;
    end

    % Minimum entropy for the attribute mm
    H(mm) = min(H_th); % Exibe o ganho de informação
end

% Information gain
I = H0 - H;

% % Plot entropy and information gain
% figure,stem(H,'.')
% axis([1 M 0 H0])
% figure,stem(I,'.')
% % axis([1 M 0 H0])

% Sort and plot features by information gain (ascending order)
[best_feat,ind_feat] = sort(I);
figure,stem(best_feat,'.')


% Show best 10 features - the best information gain are the biggest ones
ind_feat(end-9:end).'

% Sum of the information gains 
H0
sum(I)