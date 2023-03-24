%% Limpar comandos
clear
close all
clc

%% Importar banco de dados
f = importdata('base_nova_semPHQ9VALOR.csv');
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
    
    %% Treinamento
    Output = D_treino';
    Input  = S_treino';
                     %% Inicia a rede neural e define as camadas da rede MLP  
    net = feedforwardnet([10 10]);                % Cria a rede
                     %% Algoritmos de treinamento
    %net.trainFcn = 'trainrp';    % Resilient backpropagation (Rprop)
    net.trainFcn = 'trainscg'   % Scaled conjugate gradient backpropagation
    %net.trainFcn = 'trainbr';   % Bayesian regularization backpropagation
    %net.trainFcn = 'traingd';   % Gradient descent backpropagation
    %net.trainFcn = 'traingdm';  % Gradient descent backpropagation com momentum
    %net.trainFcn = 'traingda';  % Gradient descent backpropagation com taxa adaptativa
    %net.trainFcn = 'traingdx';  % Gradient descent backpropagation com momentum e taxa adaptativa
    %net.trainFcn = 'trainlm';   % Levenberg-Marquardt backpropagation (default)
    %% Função de Ativação layers{camadas ocultas} 
    %net.layers{2}.transferFcn = 'tansig' ; %Função de ativação Tangente hiperbólica 
    net.layers{2}.transferFcn = 'logsig' ; %Função de ativação  Sigmóide
    %net.layers{2}.transferFcn = 'purelin'; %Função de ativação  Linear, usada como default
    %net.layers{2}.transferFcn = 'satlin'; %Função de ativação  Linear com saturação
    %% Learning Rate do Backpropagation
    % A taxa de aprendizagem é utilizada somente na net.trainFcn = 'traingdx'
    % conhecida como gradient descent with momentum and adaptive learning rate backpropagation    
    net.trainParam.lr = 0.1; 
            
             %% Demais parâmetros
    net.divideParam.valRatio   = 0;            % conjunto de validação [%]
    net.divideParam.testRatio  = 0;            % conjunto de teste [%]
    net.trainparam.goal        = 1e-2;         % Erro máximo desejado
    net.trainParam.epochs      = 30;           % Número de épocas
    net.trainParam.showWindow  = 0;            % Não mostrar janela do treino
             %% Batch size
    net.divideParam.trainRatio = 1; % Melhor resultado com 100%      
    %net.divideParam.trainRatio = (((605/10)*9)*0.7);       
    %net.divideParam.trainRatio = 0.7;     % se 0 = 70%,30%, se 1 = 100%
    
    %(Batch Size) é um termo usado em aprendizado de máquina e refere-se
    % ao número de exemplos de treinamento usados em uma iteração.
    
    net = train(net,Input,Output);
    
    %% Teste
    In = S_teste';
    y  = D_teste';
    d  = net(In);                                                           % Testar o banco com normalização
    
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
    acc  = PE/size(y,2) %; % Se comentar o ; ele gerará os 10 folds
    figure % Gerará cada uma das matrizes de confusão
    hold on
    plotconfusion(y,out)
    cont = acc+cont;
           
end
accuracy  = cont/K;