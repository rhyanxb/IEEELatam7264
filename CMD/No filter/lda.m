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

K = 10;

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
    
    % Calcular as médias
    u(:,1) = mean(S_treino(D_treino == 1,:))';
    u(:,2) = mean(S_treino(D_treino == -1,:))';
    feat   = S_teste';
    
    for ii = 1:size(S_teste,1)
        for ll = 1:size(u,2)
            fLdA(1,ll) = ((feat(:,ii)-u(:,ll))')*(pinv(cov(S_treino)))*(feat(:,ii)-u(:,ll));
        end
        [~,CN] = min(fLdA(1,:));
        if CN == 1
            Out(ii,1) = 1;
        elseif CN == 2
            Out(ii,1) = -1;
        end
    end
    
    %% Taxa de acerto
    A = Out == D_teste;
    acc  = sum(A)/size(A,1) %;
    cont = acc+cont;
end
accuracy  = cont/K;
