function [ output output2 final_pos_1 T_1 ERROR] = r_invhandle( pos, eul)
%Função que lida / faz o tratamento da Kinematica inversa
%   Recebe como argumentos 
ERROR = 0;
output = []; output2 = []; final_pos_1 = []; T_1 = [];

% Cinematica Inversa determinando todas as soluções -----------

    IK_angs = Inverse_Kinematics(pos,eul);
    
%     % VALIDACAO dos angulos ----------------------------------

     if length(IK_angs)<1
         output = 'ERROR: No solutions found.';
         ERROR = 1;
         disp(output);
end
