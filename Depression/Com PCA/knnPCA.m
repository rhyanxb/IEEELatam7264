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
kn = 25;                              % numero de vizinhos
%v  = [1 3 5 10 15 25 40 60 84];      % numero de atributos
v = [30];
K  = 10;                             % numero de folds

for ff = 1:size(v,2)
F = feat(:,1:v(ff));

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
    acc  = sum(A)/size(A,1);
    cont = acc+cont;
end
accuracy  = cont/K
clear -regexp ^DE ^newM ^S_treino ^S_teste;
end

