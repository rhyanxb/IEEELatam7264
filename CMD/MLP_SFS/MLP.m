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
          %trainFcn = 'trainbr';   % Bayesian regularization backpropagation
          %trainFcn = 'traingd';   % Gradient descent backpropagation
          %trainFcn = 'traingdm';  % Gradient descent backpropagation com momentum
          %trainFcn = 'traingda';  % Gradient descent backpropagation com taxa adaptativa
          %trainFcn = 'traingdx';  % Gradient descent backpropagation com momentum e taxa adaptativa
          %trainFcn = 'trainlm';   % Levenberg-Marquardt backpropagation (default)         
          
          obj.net = fitnet([10 10],trainFcn);%(N_OCULTOS);
          %% Fun��o de Ativa��o layers{camadas ocultas} 
          %obj.net.layers{2}.transferFcn = 'tansig' ; %Fun��o de ativa��o Tangente hiperb�lica 
          %obj.net.layers{2}.transferFcn = 'logsig' ; %Fun��o de ativa��o  Sigm�ide
          %obj.net.layers{2}.transferFcn = 'purelin'; %Fun��o de ativa��o  Linear, usada como default
          obj.net.layers{2}.transferFcn = 'satlin'; %Fun��o de ativa��o  Linear com satura��o
                    
          %% Learning Rate do Backpropagation
          obj.net.trainParam.lr = 0.1; 
          %% Demais par�metros
           obj.net.divideParam.trainRatio = 1;            %conjunto de treino [%]
           obj.net.divideParam.valRatio   = 0;            % conjunto de valida��o [%]
           obj.net.divideParam.testRatio  = 0;            % conjunto de teste [%]
           obj.net.trainparam.goal        = 1e-2;         % Erro m�ximo desejado
           obj.net.trainParam.epochs      = 1000;         % N�mero de �pocas
           %obj.net.trainParam.showWindow  = 0;            % N�o mostrar janela do treino
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







