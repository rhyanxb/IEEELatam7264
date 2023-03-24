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
          %% Função de Ativação layers{camadas ocultas} 
          obj.net.layers{2}.transferFcn = 'tansig' ; %Função de ativação Tangente hiperbólica 
          %net.layers{2}.transferFcn = 'logsig' ; %Função de ativação  Sigmóide
          %net.layers{2}.transferFcn = 'purelin'; %Função de ativação  Linear, usada como default
          %net.layers{2}.transferFcn = 'satlin'; %Função de ativação  Linear com saturação
          %% Learning Rate do Backpropagation
          obj.net.trainParam.lr = 0.1; 
          %% Demais parâmetros
           %% Demais parâmetros
           net.divideParam.valRatio   = 0;            % conjunto de validação [%]
           net.divideParam.testRatio  = 0;            % conjunto de teste [%]
           net.trainparam.goal        = 1e-2;         % Erro máximo desejado
           net.trainParam.epochs      = 1000;           % Número de épocas
           %net.trainParam.showWindow  = 0;            % Não mostrar janela do treino
          
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







