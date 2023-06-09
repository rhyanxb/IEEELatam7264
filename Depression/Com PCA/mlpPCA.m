%% Limpar comandos
clear
close all
clc

%% Importar banco de dados
f = importdata('base_nova_semPHQ9VALOR.csv');
feat = PCA(f(:,1:84));
C    = f(:,85);
C((C == 0),1) = -1;

%% Par�metros
%v = [1 3 5 10 15 25 40 60 84];      % numero de atributos
v = [80];
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
    Output = D_treino';
    Input  = S_treino';
    
     %% Inicia a rede neural e define as camadas da rede MLP  
    net = feedforwardnet([10 10]);                % Cria a rede
                     %% Algoritmos de treinamento
    net.trainFcn = 'trainrp';   % Resilient backpropagation (Rprop)
    %net.trainFcn = 'trainscg'   % Scaled conjugate gradient backpropagation
    %net.trainFcn = 'trainbr';   % Bayesian regularization backpropagation
    %net.trainFcn = 'traingd';   % Gradient descent backpropagation
    %net.trainFcn = 'traingdm';  % Gradient descent backpropagation com momentum
    %net.trainFcn = 'traingda';  % Gradient descent backpropagation com taxa adaptativa
    %net.trainFcn = 'traingdx';  % Gradient descent backpropagation com momentum e taxa adaptativa
    %net.trainFcn = 'trainlm';   % Levenberg-Marquardt backpropagation (default)
    %% Fun��o de Ativa��o layers{camadas ocultas} 
    net.layers{2}.transferFcn = 'tansig' ; %Fun��o de ativa��o Tangente hiperb�lica 
    %net.layers{2}.transferFcn = 'logsig' ; %Fun��o de ativa��o  Sigm�ide
    %net.layers{2}.transferFcn = 'purelin'; %Fun��o de ativa��o  Linear, usada como default
    %net.layers{2}.transferFcn = 'satlin'; %Fun��o de ativa��o  Linear com satura��o
    %% Learning Rate do Backpropagation
    % A taxa de aprendizagem � utilizada somente na net.trainFcn = 'traingdx'
    % conhecida como gradient descent with momentum and adaptive learning rate backpropagation    
    net.trainParam.lr = 0.1; 
            
             %% Demais par�metros
    net.divideParam.valRatio   = 0;            % conjunto de valida��o [%]
    net.divideParam.testRatio  = 0;            % conjunto de teste [%]
    net.trainparam.goal        = 1e-2;         % Erro m�ximo desejado
    net.trainParam.epochs      = 20;           % N�mero de �pocas
    net.trainParam.showWindow  = 0;            % N�o mostrar janela do treino
             %% Batch size
    net.divideParam.trainRatio = 1; % Melhor resultado com 100%      
    %net.divideParam.trainRatio = (((605/10)*9)*0.7);       
    %net.divideParam.trainRatio = 0.7;     % se 0 = 70%,30%, se 1 = 100%
    
    net = train(net,Input,Output);
    
    %% Teste
    In = S_teste';
    y  = D_teste';
    d  = net(In);                                                           % Testar o banco com normaliza��o
    
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
accuracy  = cont/K
clear -regexp ^newM ^S_treino ^D_treino ^Input ^Output ^net ^S_teste ^D_teste;
end
