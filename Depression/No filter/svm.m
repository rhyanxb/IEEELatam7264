%% Limpar comandos
clear
close all
clc

%% Importar banco de dados
f = importdata('base_nova_semPHQ9VALOR.csv');
M = zscore(f(:,1:end-1));              % Testar normalizando o banco
%M = f(:,1:end-1);                     % Testar sem normalizar 

%% Parâmetros
C = f(:,end);
K = 10;
newM = [M C];
cont = 0;

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
    
    %% Treinamento   Obs:. O Standardize se true é z-score 
    
    %SVMModels = fitcsvm(S_treino,D_treino,'Standardize',true,'KernelFunction', ...
    %'linear','BoxConstraint',1);  % Kernel linear
    
    %SVMModels = fitcsvm(S_treino,D_treino,'Standardize', true, 'KernelFunction', ...
    %'RBF','BoxConstraint',0.91,'Kernelscale','auto');
    
    %gamma=0.01;
    %SVMModels = fitcsvm(S_treino,D_treino,'Standardize', true,'KernelFunction', ...
    %'RBF','BoxConstraint',0.91,'Kernelscale', 1/sqrt(2*gamma));
    
    %SVMModels = fitcsvm(S_treino,D_treino,'Standardize', true, 'KernelFunction', ...
    %'polynomial','BoxConstraint',0.91,'Kernelscale','auto');
    
    %SVMModels = fitcsvm(S_treino,D_treino,'Standardize', true, 'KernelFunction', ...
    %'polynomial','PolynomialOrder',3,'BoxConstraint',1,'Kernelscale','auto');
    
    SVMModels = fitcsvm(S_treino,D_treino,'Standardize', false, 'KernelFunction', ...
    'gaussian','BoxConstraint',0.89,'Kernelscale','auto');
     
    %SVMModels = fitcsvm(S_treino,D_treino,'Standardize', true, 'KernelFunction', ...
    %'mysigmoid','BoxConstraint',10);   %Obs. Usa a função mysigmoid
    
    %% Teste
    for ii = 1:size(S_teste,1)
        d(ii,1) = predict(SVMModels,S_teste(ii,:));
    end
    
    %% Taxa de acerto
    A = d == D_teste;
    acc  = sum(A)/size(A,1);
    cont = acc+cont;
end
accuracy  = cont/K;

