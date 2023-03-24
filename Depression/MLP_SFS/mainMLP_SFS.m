%Limpa os dados e fecha janelas
clear all;
close all;
clc

% Carrega Dataset
%dataset = load('base_nova.csv');
dataset = load('base_nova_semPHQ9VALOR.csv');
X = zscore(dataset(:,1:end - 1));
%X = dataset(:,1:end - 1);
Y = dataset(:,end);

%N_OCULTOS = round( (size(X, 2) + 1)/2);
N_OCULTOS = 10; %round( (size(X, 2) + 1)/2);

%Validação cruzada por KFold 
c = cvpartition(Y,'KFold',10);
Y_Train = Y(training(c,1), 1);

colunas = []; % guarda os atributos selecionados
menor_erro = inf; % guarda sempre o último menor erro

for iter = 1 : size(X, 2)
    coluna_selected = -1; % guarda o atributo selecionado em cada passo
    
    for coluna = 1 : size(X, 2)
        if ismember(coluna, colunas) == 0
            % Seleciona um atributo para classificar
            X_Train = X(training(c,1),[ colunas coluna] );

            % Aplica MLP com o atributo selecionado
            Model = MLP(N_OCULTOS);
            Model = treinar(Model, X_Train, Y_Train);
            [Predicted] = classificar(Model, X(test(c,1), [ colunas coluna] ));

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
         disp(' Nenhuma coluna foi adicionada ')
         break; % se nehuma coluna a mais for selecionada
    else    
        colunas = [colunas coluna_selected];
        disp( [' Passo ' num2str(iter) ': adicionada a coluna ' num2str(coluna_selected)])
    end
    
end

%Avalia o classificador com os atributos selecionados
%Validação cruzada por KFold 
c = cvpartition(Y,'KFold',10);
Y_Train = Y(training(c,1), 1);

X_Train = X(training(c,1), colunas );

Model = MLP(N_OCULTOS);
Model = treinar(Model, X_Train, Y_Train);
[Predicted] = classificar(Model, X(test(c,1), colunas ));

% Calcula taxa de erro
[conf, ~] = confusionmat(Y(test(c,1)),Predicted);
taxa_acerto = trace(conf)/sum(conf(:));

disp(['Colunas selecionadas: ' mat2str(colunas)])
disp(['Taxa de acerto:' num2str(taxa_acerto)])
