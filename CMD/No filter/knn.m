%% Limpar comandos
clear
close all
clc

%% Importar banco de dados
f = importdata('base_novatmc_semSQR20.csv');
M = zscore(f(:,1:end-1));
%M = f(:,1:end-1);
C = f(:,end);
C((C == 0),1) = -1;

newM = [M C];
cont = 0;

%% Parâmetros
K  = 10; % Numero de folders
kn = 75;  % Numero de vizinhos

for k=1:K
    %% Dividir o banco em treino e teste
    a = 1;  % Contar linhas da matriz de teste
    b = 1;  % Contar linhas da matriz de treino
    c = 0;  % Contador
    
    for ind = 1:size(newM,1)
         if ind == k+c
            S_teste(a,:) = newM(ind,1:end-1);
            D_teste(a,:) = newM(ind,end);
            a = a+1;
            c = c+K;
        else
            S_treino(b,:) = newM(ind,1:end-1);
            D_treino(b,:) = newM(ind,end);
            b = b+1;
        end
    end
    
    for ii = 1:size(S_teste,1)
        for jj = 1:size(S_treino,1)
            DE(1,jj) = norm(S_teste(ii,:)-S_treino(jj,:));
        end
        [~,idx]   = sort(DE);
        d_m       = D_treino(idx(1:kn),:);
        Out(ii,:) = mode(d_m);
    end
    
    %% Taxa de acerto
    A = Out == D_teste;
    acc  = sum(A)/size(A,1) %;
    cont = acc+cont;
end
accuracy  = cont/K;