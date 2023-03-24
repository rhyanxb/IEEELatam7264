%% Algoritmo PCA
function [feat] = PCA(dados)
    med   = mean(dados);                                                    % Médias
    val   = dados - repmat(med,size(dados,1),1);                            % Subtrair médias 
    M_cov = cov(val);                                                       % Matriz de covariancia 
    [U,V] = eig(M_cov);                                                     % Autovetores e autovalores

    a_val = diag(V);                                                        % Pegar os autovalores
    [a,b] = sort(a_val);
    b     = sort(b, 'descend');

    aut_v = U(:,b);                                                         % Ordenar de forma decrescente os autovetores

    n_val = val*aut_v;                                                      % Multiplicar os dados pelos autovetores
    feat  = zscore(n_val);                                                  % Normalizar o resultado
    %feat  = n_val;
end