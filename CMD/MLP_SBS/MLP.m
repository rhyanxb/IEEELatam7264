classdef MLP  < handle
    
     % DEFINE ARQUITETURA DA REDE
     properties
        net % objeto
        flag
     end
 
     methods
      
      % Construtor da classe
      function obj = MLP(N_OCULTOS)
          %% Algoritmos de treinamento
          %trainFcn = 'trainrp';   % Resilient backpropagation (Rprop)
          trainFcn = 'trainscg'   % Scaled conjugate gradient backpropagation
          %net.trainFcn = 'trainbr';   % Bayesian regularization backpropagation
          %net.trainFcn = 'traingd';   % Gradient descent backpropagation
          %net.trainFcn = 'traingdm';  % Gradient descent backpropagation com momentum
          %net.trainFcn = 'traingda';  % Gradient descent backpropagation com taxa adaptativa
          %net.trainFcn = 'traingdx';  % Gradient descent backpropagation com momentum e taxa adaptativa
          %net.trainFcn = 'trainlm';   % Levenberg-Marquardt backpropagation (default)
          obj.net = fitnet([10 10],trainFcn);%(N_OCULTOS);
          %% Fun��o de Ativa��o layers{camadas ocultas} 
          obj.net.layers{2}.transferFcn = 'tansig' ; %Fun��o de ativa��o Tangente hiperb�lica 
          %net.layers{2}.transferFcn = 'logsig' ; %Fun��o de ativa��o  Sigm�ide
          %net.layers{2}.transferFcn = 'purelin'; %Fun��o de ativa��o  Linear, usada como default
          %net.layers{2}.transferFcn = 'satlin'; %Fun��o de ativa��o  Linear com satura��o
          %% Learning Rate do Backpropagation
          obj.net.trainParam.lr = 0.1; 
          %% Demais par�metros
           %% Demais par�metros
           net.divideParam.valRatio   = 0;            % conjunto de valida��o [%]
           net.divideParam.testRatio  = 0;            % conjunto de teste [%]
           net.trainparam.goal        = 1e-2;         % Erro m�ximo desejado
           net.trainParam.epochs      = 1000;           % N�mero de �pocas
           %net.trainParam.showWindow  = 0;            % N�o mostrar janela do treino
          
          %% Batch size
           net.divideParam.trainRatio = 1; % Melhor resultado com 100%      
           %net.divideParam.trainRatio = (((605/10)*9)*0.7);       
           %net.divideParam.trainRatio = 0.7;     % se 0 = 70%,30%, se 1 = 100%
             
      end 
      
      function obj = treinar(obj, Xtrain, Ytrain)   
                    
        Input = Xtrain'; 
        Output = Ytrain';
        
        obj.net = train(obj.net, Input, Output);
      end
      
     function predicted = classificar(obj, Xtest) 
        In = Xtest';
        [predicted] = round( abs( obj.net(In)' ) );
     end
    
   end % methods
end % classdef







