classdef OutPut < handle
    
   % Define os atributos da classe
   properties
      diretorio % diretorio principal
      arquivo % arquivo onde vai ser salvo os resultados
      pasta % pasta que vai armazenar os graficos
   end
   
   methods
      
   % Construtor da classe
   function obj = OutPut(destino, titulo)
        %cria o diretorio para armazenar os dados
     
        c = clock;
        tempo = ['_' num2str(c(1,4)) 'h' num2str(c(1,5)) 'min' num2str( c(1,5)) 's' ];
        
        obj.diretorio = ['resultados/' destino '/resultados_' date tempo '/'];
        
        if exist(obj.diretorio, 'dir') == 0
            mkdir(obj.diretorio);
        end
        
        % cria o arquivo para armazenar os resultados
        path = [ obj.diretorio 'resultado.txt'];
        
        disp(path);
        
        obj.arquivo = fopen(path,'w');
        fprintf(obj.arquivo,'' );
        fclose(obj.arquivo);
        obj.arquivo = fopen(path,'a');
        fprintf(obj.arquivo,['Resultados: ' titulo '\n']);

   end
   
   function escreverMatriz(obj, matriz) 
       
       fprintf(obj.arquivo, 'MATRIZ --------------------------\n' );
       for i = 1 : size(matriz, 1)
            fprintf(obj.arquivo, [ num2str( matriz(i, :) ) '\n' ] );  
       end
       fprintf(obj.arquivo, '---------------------------------\n\n' );      
   end
       
   function escrever(obj, saida)   
        fprintf(obj.arquivo,[ saida '\n']);  
        disp(saida)
   end
   
   function savarGrafico(obj, nome, figura)    
        path = [ obj.diretorio nome '.png' ];
        
        print( figura ,path, '-dpng');
        
       % saveas(figura, path, 'png');
   end
   
   function close(obj)         
        fclose(obj.arquivo);          
   end
      
	
   end % methods
end % classdef     