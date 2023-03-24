%Limpa os dados e fecha janelas
clear all;
close all;
clc

% Carrega Dataset
dataset = load('base_novatmc_semSQR20.csv');
X = dataset(:,1:end - 1);
Y = dataset(:,end);

% Normaliza��o de dados
X = zscore(X);

%N_OCULTOS = round((size(X, 2) + 1)/2);
N_OCULTOS = 10; %round( (size(X, 2) + 1)/2);

% Valida��o cruzada por K-Fold = 10  
c = cvpartition(Y,'KFold',10);
Y_Train = Y(training(c,1), 1);

colunas = 1 : size(X, 2); % guarda os atributos selecionados
menor_erro = inf; % guarda sempre o �ltimo menor erro

for iter = 1 : size(X, 2)
    coluna_removida = -1; % guarda o atributo removido em cada passo
    
    for coluna = 1 : size(X, 2)
        if ismember(coluna, colunas) == 1
            % Remove um atributo para classificar
            X_Train = X(training(c,1),colunas( colunas ~= coluna) );

            % Aplica MLP com o atributo removido
            Model = MLP(N_OCULTOS);
            Model = treinar(Model, X_Train, Y_Train);
            [Predicted] = classificar(Model, X(test(c,1), colunas( colunas ~= coluna) ));

            % Calcula taxa de erro
            [conf, ~] = confusionmat(Y(test(c,1)),Predicted);
            taxa_erro = 1 - trace(conf)/sum(conf(:));

            % O atributo Ni ser� selecionado com os outros j� selecionados tiver menor
            % erro de acur�cia
            if menor_erro > taxa_erro
                menor_erro = taxa_erro;
                coluna_removida = coluna;
            end % fecha o if
        end % fecha o if
    end % fecha o for
    
    if coluna_removida == -1
         disp(' Nenhuma coluna foi removida ')
         break; % se nehuma coluna a mais for removida
    else    
        colunas = colunas( colunas ~= coluna_removida);
        disp( [' Passo ' num2str(iter) ': removida a coluna ' num2str(coluna_removida)])
    end
    
end

% Avalia o classificador com os atributos selecionados

% Valida��o cruzada por K-Fold = 10 
c = cvpartition(Y,'k',10);
Y_Train = Y(training(c,1), 1);

% Ordena os atributos
colunas = sort(colunas);

% Aplica MLP com os atributos selecionados
Model = MLP(N_OCULTOS);
X_Train = X(training(c,1), colunas );
Model = treinar(Model, X_Train, Y_Train);
[Predicted] = classificar(Model, X(test(c,1), colunas ));

% Calcula taxa de acerto
[conf, ~] = confusionmat(Y(test(c,1)),Predicted);
taxa_acerto = trace(conf)/sum(conf(:));

disp(['Colunas selecionadas: ' mat2str(colunas)])
disp(['Taxa de acerto:' num2str(taxa_acerto)])
