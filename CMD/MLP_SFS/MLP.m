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
          %% Função de Ativação layers{camadas ocultas} 
          %obj.net.layers{2}.transferFcn = 'tansig' ; %Função de ativação Tangente hiperbólica 
          %obj.net.layers{2}.transferFcn = 'logsig' ; %Função de ativação  Sigmóide
          %obj.net.layers{2}.transferFcn = 'purelin'; %Função de ativação  Linear, usada como default
          obj.net.layers{2}.transferFcn = 'satlin'; %Função de ativação  Linear com saturação
                    
          %% Learning Rate do Backpropagation
          obj.net.trainParam.lr = 0.1; 
          %% Demais parâmetros
           obj.net.divideParam.trainRatio = 1;            %conjunto de treino [%]
           obj.net.divideParam.valRatio   = 0;            % conjunto de validação [%]
           obj.net.divideParam.testRatio  = 0;            % conjunto de teste [%]
           obj.net.trainparam.goal        = 1e-2;         % Erro máximo desejado
           obj.net.trainParam.epochs      = 1000;         % Número de épocas
           %obj.net.trainParam.showWindow  = 0;            % Não mostrar janela do treino
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







