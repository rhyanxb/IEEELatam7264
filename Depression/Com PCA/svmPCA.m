%% Limpar comandos
clear               % O z-score é feito depois do PCA, O PCA não tem zscore;
close all           % As médias dos atributos foram removidas antes do PCA;  
clc                 % deve subtrair a média e depois obter os auto-valores e auto-vetores da matriz de covariância.

%% Importar banco de dados
f = importdata('base_nova_semPHQ9VALOR.csv');
feat = PCA(f(:,1:84));  
                                                              
%% Parâmetros
C = f(:,85);
K = 10;
%v = [1 3 5 10 15 25 40 60 84];      % numero de atributos/componentes
v = [79];
 
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
    %% Treinamento
    %SVMModels = fitcsvm(S_treino,D_treino,'Standardize',false,'KernelFunction', ...
    %'linear','BoxConstraint',1);  % Kernel linear
    
    %SVMModels = fitcsvm(S_treino,D_treino,'Standardize', true, 'KernelFunction', ...
    %'RBF','BoxConstraint',100,'Kernelscale','auto');
    
    %SVMModels = fitcsvm(S_treino,D_treino,'Standardize', true, 'KernelFunction', ...
    %'polynomial','BoxConstraint',1,'Kernelscale','auto');
    
    SVMModels = fitcsvm(S_treino,D_treino,'Standardize', true, 'KernelFunction', ...
    'gaussian','BoxConstraint',1,'Kernelscale','auto');
    
    %% Teste
    for ii = 1:size(S_teste,1)
        d(ii,1) = predict(SVMModels,S_teste(ii,:));
    end
    
    %% Taxa de acerto
    A = d == D_teste;
    acc  = sum(A)/size(A,1) %;
    cont = acc+cont;
end
accuracy  = cont/K;
clear -regexp ^D_treino ^D_teste ^S_teste ^S_treino
end