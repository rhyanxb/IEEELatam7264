classdef SVM  < handle
     properties
        model
     end
 
     methods
      
      % Construtor da classe
      function obj = SVM() 
      end 
      
      function obj = treinar(obj, Xtrain, Ytrain) 
          
       %obj.model = fitcsvm(Xtrain,Ytrain,'Standardize',false,'KernelFunction', ...
       %'linear','BoxConstraint',3);  % Kernel linear

       %obj.model = fitcsvm(Xtrain,Ytrain,'Standardize', false, 'KernelFunction', ...
       %'RBF','BoxConstraint',100,'Kernelscale','auto');

        
        %obj.model = fitcsvm(Xtrain,Ytrain,'Standardize', false,'KernelFunction', ...
        %'RBF','BoxConstraint',2,'Kernelscale', 1/sqrt(2*gamma));

        %obj.model = fitcsvm(Xtrain,Ytrain,'Standardize', false, 'KernelFunction', ...
        %'polynomial','BoxConstraint',1,'Kernelscale','auto');

        %obj.model = fitcsvm(Xtrain,Ytrain,'Standardize', false, 'KernelFunction', ...
        %'polynomial','PolynomialOrder', 2,'BoxConstraint',1,'Kernelscale','auto');

        %obj.model = fitcsvm(Xtrain,Ytrain,'Standardize', false, 'KernelFunction', ...
        %'mysigmoid','BoxConstraint',1);   %Obs. Usa a função mysigmoid
          
        %obj.model = fitcsvm(Xtrain,Ytrain,'Standardize', false, 'KernelFunction', ...
        %'gaussian','BoxConstraint',1,'Kernelscale','auto');
        %gamma=0.0089;
        obj.model = fitcsvm(Xtrain,Ytrain,'Standardize', false, 'KernelFunction', ...
        'gaussian','BoxConstraint',10,'Kernelscale', 0.8);
      end
      
     function predicted = classificar(obj, Xtest) 
        
        predicted = zeros(size(Xtest, 1), 1);
        
        for i = 1 : size(Xtest,1)
            predicted(i,:) = predict(obj.model,Xtest(i,:));
        end
        
     end
    
   end % methods
end % classdef







