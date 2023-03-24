%Limpa os dados e fecha janelas
clear all;
close all;
clc

% Carrega Dataset
dataset = load('base_nova_semPHQ9VALOR.csv');
X = dataset(:,1:end - 1);
Y = dataset(:,end);

% Normalização de dados
X = zscore(X);

% Objeto para salvar os resultados
out = OutPut('SVM_SBS', 'SVM com SBS implementado\n\n');

% Validação cruzada por K-Fold = 10  
c = cvpartition(Y,'k',10);
Y_Train = Y(training(c,1), 1);

colunas = 1 : size(X, 2); % guarda os atributos selecionados
menor_erro = inf; % guarda sempre o último menor erro

for iter = 1 : size(X, 2)
    coluna_removida = -1; % guarda o atributo removido em cada passo
    
    for coluna = 1 : size(X, 2)
        if ismember(coluna, colunas) == 1
            % Remove um atributo para classificar
            X_Train = X(training(c,1),colunas( colunas ~= coluna) );

            % Aplica SVM com o atributo removido
            Model = SVM();
            Model = treinar(Model, X_Train, Y_Train);
            [Predicted] = classificar(Model, X(test(c,1), colunas( colunas ~= coluna) ));

            % Calcula taxa de erro
            [conf, ~] = confusionmat(Y(test(c,1)),Predicted);
            taxa_erro = 1 - trace(conf)/sum(conf(:));

            % O atributo Ni será selecionado com os outros já selecionados tiver menor
            % erro de acurácia
            if menor_erro > taxa_erro
                menor_erro = taxa_erro;
                coluna_removida = coluna;
            end % fecha o if
        end % fecha o if
    end % fecha o for
    
    if coluna_removida == -1
         out.escrever(' Nenhuma coluna foi removida ')
         break; % se nenhuma coluna a mais for removida
    else    
        colunas = colunas( colunas ~= coluna_removida);
        out.escrever( [' Passo ' num2str(iter) ': removida a coluna ' num2str(coluna_removida)])
    end
    
end

% Avalia o classificador com os atributos selecionados

% Validação cruzada por K-Fold = 10 
c = cvpartition(Y,'k',10);
Y_Train = Y(training(c,1), 1);

% Ordena os atributos
colunas = sort(colunas);

% Aplica SVM com os atributos selecionados
Model = SVM();
X_Train = X(training(c,1), colunas );
Model = treinar(Model, X_Train, Y_Train);
[Predicted] = classificar(Model, X(test(c,1), colunas ));

% Calcula taxa de acerto
[conf, ~] = confusionmat(Y(test(c,1)),Predicted);
taxa_acerto = trace(conf)/sum(conf(:));

out.escrever(['Colunas selecionadas: ' mat2str(colunas)])
out.escrever(['Taxa de acerto:' num2str(taxa_acerto)])
out.close()

