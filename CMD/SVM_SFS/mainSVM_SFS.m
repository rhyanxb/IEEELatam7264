%Limpa os dados e fecha janelas
clear all;
close all;
clc

% Carrega Dataset
dataset = load('base_novatmc_semSQR20.csv');
X = dataset(:,1:end - 1);
Y = dataset(:,end);

% Objeto para salvar os resultados
out = OutPut('SVM_SFS', 'SVM com SFS implementado\n\n');

% Normalização de dados
X = zscore(X);

% Validação cruzada por K-Fold = 10  
c = cvpartition(Y,'k',10);
Y_Train = Y(training(c,1), 1);

colunas = []; % guarda os atributos selecionados
menor_erro = inf; % guarda sempre o último menor erro

for iter = 1 : size(X, 2)
    coluna_selected = -1; % guarda o atributo selecionado em cada passo
    
    for coluna = 1 : size(X, 2)
        if ismember(coluna, colunas) == 0
            % Seleciona um atributo para classificar
            X_Train = X(training(c,1),[ colunas coluna] );

            % Aplica SVM com o atributo selecionado
            Model = SVM();
            Model = treinar(Model, X_Train, Y_Train);
            [Predicted] = classificar(Model, X(test(c,1), [colunas coluna] ));

            % Calcula taxa de erro
            [conf, ~] = confusionmat(Y(test(c,1)),Predicted);
            taxa_erro = 1 - trace(conf)/sum(conf(:));

            % O atributo Ni será selecionado com os outros já selecionados tiver menor
            % erro de acurácia
            if menor_erro > taxa_erro
                menor_erro = taxa_erro;
                coluna_selected = coluna;
            end % fecha o if
        end % fecha o if
    end % fecha o for
    
    if coluna_selected == -1
         out.escrever(' Nenhuma coluna foi adicionada ')
         break; % se nenhuma coluna a mais for selecionada
    else    
        colunas = [colunas coluna_selected];
        out.escrever( [' Passo ' num2str(iter) ': adicionada a coluna ' num2str(coluna_selected)])
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

out.escrever(['Colunas selecionadas: ' mat2str(colunas)]);
out.escrever(['Taxa de acerto:' num2str(taxa_acerto)]);
out.close();
