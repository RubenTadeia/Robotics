%% Laboratório 1
%
% *Robótica*
%
% *2º Semestre 2015/2016*
%
% *Laboratório 1*
%
% * Ana Catarina Rosa Gonçalves - 73177
%
% * Rúben Miguel Oliveira Tadeia - 75268
%
% * David Luís Dias Fernandes - 75912
%
%%
% Script: Main da Laboratório 1

% (1) Display do Menu Principal, obtenção da cinemática (Directa/Inversa)
% e execução das respectivas funções.
close all;

while(42==42) % script's main loop
    
    fprintf( '  Laboratório Nº1 \n\n');
    disp('  [1] - Cinematica Directa ');
    disp('  [2] - Cinematica Inversa ');
    disp('  [q] - Terminar o programa ');
    
    opcao = input('\n Introduza o modo a resolver: ','s');
    
    quit=0; % variavel para sair dos ciclos cinematicos
    
    switch(opcao(1))
        case 'q'
            break;
        case '1' % CINEMATICA DIRECTA -------------------------------------
            while(~quit)
                % Inserção do vector de entrada (input)
                % Este vector contem os 5 angulos das varias juntas
                disp('Introduza um array com os 5 angulos das varias juntas.');
                disp('Este deve ser do genero [Teta1 Teta2 Teta3 Teta4 Teta5 Teta6]');
                disp('NOTA: Intervalo de accao das juntas:');
                
                IN_angle = input('INPUT: ');
                
                % Rotina do Direct Kinematics: Posição final e plots
                [OUT_pos, T, final_pos, eul, ERROR] = r_dirhandle(IN_angle);
                
                % plots
                r_plots(final_pos,T,IN_angle(6));
     
                
                quit = input('Deseja sair deste modo?\n0 - Nao\n1 - Sim\n');
            end
            
            
         case '2' % CINEMATICA INVERSA -------------------------------------
            while(~quit)
                
                % Input
                disp('Introduza um vector com a posicao do end efector que pretende');
                disp('Este deve ser do genero [x y z Alfa Beta Gama].');
                disp('NOTA: Intervalo de accao das juntas:');
                posicao_xyz = input('INPUT: ');
                
                % Rotina da cinematica inversa: angulos finais e plots
                
                [OUT_angs OUT_n final_pos T ERROR] = r_invhandle(final_pos(:,4),eul);
                disp(OUT_n);
                
                % plots
                if ~ERROR
                    r_plots(final_pos,T,posicao_xyz(6));
                end 
             
                % Iniciar, mover e encerrar o robot
                if ~ERROR &&mode(3)=='1'
                    r_movebot(r_DegToBit(OUT_angs(1,:)));
                end
                quit = input('Deseja sair deste modo?\n0 - Nao\n1 - Sim\n');
            end
            
            otherwise % Erro na Opcao
            fprintf('\n[ERRO] Escolha uma opção válida!');
    end
    
end

