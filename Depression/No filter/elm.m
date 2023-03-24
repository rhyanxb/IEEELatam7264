%% Limpar comandos
clear
close all
clc

%% Importar banco de dados
f = importdata('base_nova_semPHQ9VALOR.csv');
m = zscore(f(:,1:end-1));
%m = f(:,1:end-1);
C = f(:,end);
C((C == 0),1) = -1;

newM = [m C];
cont = 0;

%% Parâmetros
q = 40;          % Numero de neurônios pra base
p = size(m,2);
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
    
    %% Treinamento
    sz = size(S_treino);
    X  = [ones(1,sz(1,1)); S_treino'];
    D  = D_treino';

    rng('default');
    rng(1);
    W = randn(q,p+1);

    Z = W*X;
    Z = 1./(1+exp(-Z));
    Z = [ones(1,sz(1,1)); Z];

    M = (D*Z')*pinv(Z*Z');

    %% Teste
    tm = size(S_teste);
    x  = [ones(1,tm(1,1)); S_teste'];
    y  = D_teste';

    z = W*x;
    z = 1./(1+exp(-z));
    z = [ones(1,tm(1,1)); z];

    d = M*z;
    
    %% Taxa de acerto
    PE = 0;
    for ii = 1:size(y,2)
        if (y(ii) >= 0 && d(ii) >=0) || (y(ii) < 0 && d(ii) < 0)
            PE = PE+1;
        end
         if d(ii) < 0
            out(ii) = 0;
        elseif d(ii) >= 0
            out(ii) = 1;
        end   
    end
    %acc  = PE/size(y,2) %; Removendo o ponto e vírgula ele mostrará os 10 folds individualmente
    %cont = acc+cont;
    
    y((y == -1))= 0;
    acc  = PE/size(y,2); % comenetando o ; ele mostra os 10 folds
    %figure
    %hold on
    %plotconfusion(y,out)
    cont = acc+cont;
end
accuracy  = cont/K;
