%% Limpar comandos
clear
close all
clc

%% Importar banco de dados
f = importdata('base_nova_semPHQ9VALOR.csv');
feat = PCA(f(:,1:84));
C    = f(:,85);
C((C == 0),1) = -1;

%% Parâmetros
q = 80;                             % neurônios
%v = [1 3 5 10 15 25 40 60 84];     % numero de atributos
v = [40];
K = 10;                             % numero de folds

for ff = 1:size(v,2)
F = feat(:,1:v(ff));
p = v(ff);

cont = 0;
newM = [F C];

for k = 1:K
    %% Dividir o banco em treino e teste
    a = 1;  % Contar linhas da matriz de teste
    b = 1;  % Contar linhas da matriz de treino
    c = 0;  % Contador
    
    for ind = 1:size(newM,1)
         if ind == k+c
            S_teste(a,:) = newM(ind,1:v(ff));
            D_teste(a,:) = newM(ind,v(ff)+1);
            a = a+1;
            c = c+K;
        else
            S_treino(b,:) = newM(ind,1:v(ff));
            D_treino(b,:) = newM(ind,v(ff)+1);
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
    y((y == -1))= 0;
    acc  = PE/size(y,2);
    %figure
    %hold on
    %plotconfusion(y,out)
    cont = acc+cont;
end
clear -regexp ^M ^Z ^D ^newM ^S_treino ^S_teste;
accuracy  = cont/K %;
end