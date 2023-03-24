clc
clear all
close all

% Load database
load basenovatmcsemSQR20 basenovatmcsemSQR20
X = basenovatmcsemSQR20(:,1:end-1);
y = basenovatmcsemSQR20(:,end);
clear basenovatmcsemSQR20
[N M] = size(X); % N: number of samples, M: number of features

% Gini diversity index of the original databese
G0 = gini_binary_signal(y); 

% Loop for the features
for mm = 1:M
    
    % Threshold candidates for the division of the data
    th_cand = threshold_candidates(X(:,mm),y);
    
    % Calculating the Gini diversity index of the divided data using the threshold candidates
    clear G_th
    for tt = 1:length(th_cand)
        G_higher = gini_binary_signal(y(find(X(:,mm) > th_cand(tt))));
        G_lower = gini_binary_signal(y(find(X(:,mm) <= th_cand(tt))));
        G_th(tt) = (length(y(find(X(:,mm)>th_cand(tt))))*G_higher + length(y(find(X(:,mm)<=th_cand(tt))))*G_lower)/N;
    end

    % Minimum Gini diversity index for the attribute mm
    G(mm) = min(G_th); % Exibe o índice de Gini de cada variável
end

% % Plot Gini diversity index
% figure,stem(G,'.')

% Sort and plot features by Gini diversity index (ascending order)
[best_feat,ind_feat] = sort(G);
figure,stem(best_feat,'.')
hold on, plot(G0*ones(length(best_feat),1),'r')

% Show best 10 features - the best Gini diversity indices are the smaller
% ones
flip(ind_feat(1:10).')


