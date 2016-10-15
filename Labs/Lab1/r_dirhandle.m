function [ OUT, T, final_pos, eul, ERROR ] = r_dirhandle( angles )
%R_DIRHANDLE Executa o handle da Cinematica Directa
%   R_DIRHANDLE(ANGLES) Recebe os angulos de input do interface grafico e
%   executa a rotina da Cinematica Directa. Devolve o vector de posicao do
%   End Effector no World Frame e faz os plots 3D e 2D do manipulador.

ERROR = 0;
OUT = [];
eul= [];


% Cinematica Directa ------------------------------------
[final_pos T]= r_DirectKinematics(angles);
disp(T);
%Cálculo da Orientação Z-Y-Z

beta = atan2(sqrt(T(1,3)^2 + T(2,3)^2), T(3,3));
beta1 = rad2deg(beta);
if(sin(beta)>0)
    gama = rad2deg(atan2(T(3,2),-T(3,1)));
   alpha = rad2deg(atan2(T(2,3),T(1,3)));
    
else
   gama = rad2deg(atan2(-T(3,2),T(3,1)));
    alpha = rad2deg(atan2(-T(2,3),-T(1,3)));
end
%Cálculo da orientação Z-X-Z
%alpha2 = atan2(T(1,3), -T(2,3));
%beta2 = atan2(-T(2,3)*cos(alpha)+ T(1,3)*sin(alpha), T(3,3));
%psi2 = atan2(T(3,1), T(3,2));


eul = [alpha beta1 gama];
rotm = eul2rotm(eul,'ZYZ');
disp(rotm)
OUT = ['OUTPUT: [x y z] = [',num2str(final_pos(1:3,4)'),']'];
%r_plots(final_pos,T,angles(6));
    
disp(OUT);
end