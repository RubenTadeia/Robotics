function [final_pos T]= r_DirectKinematics(joint_angles)
%                    CONVENCAO D-H
%     alfa_i-1   a_i-1    d_i       teta_i

if length(joint_angles)>5	%% simulacao
    %Matriz com os Parametros de denavit hartenberg
	D_H = [  0        0      99    joint_angles(1)*pi/180;
		-pi/2    0      0     joint_angles(2)*pi/180;
		0       120    0     joint_angles(3)*pi/180;
        pi/2    0      0      pi/2;
		pi/2   0      0     joint_angles(4)*pi/180;
         -pi/2     0   0   -pi/2;
		-pi/2   147    0   joint_angles(5)*pi/180;
        pi/2  30  0 pi/2
        pi/2   0     0    joint_angles(6)*pi/180];
      
end
% calcula as varias matrizes de transformacao i_T
i_T=zeros(4,4,9);
T=eye(4);
for i=1:9
	i_T(:,:,i)=transform(D_H(i,:));
    
	T=T*i_T(:,:,i);
end

% final_pos guarda as posicoes de cada junta (x,y,z) para serem testadas
% para validar o input => matriz_3x3 porque Teta 1 e Teta 2 estao fixos.
% os pontos estao todos na posicao homogenea [0 0 0 1]' por se considerar
% que as juntas sao a origem do referencial de cada moldura.

% Matrizes de transformação incluindo as transformações auxiliares
aux_pos(:,1)=i_T(:,:,1)*i_T(:,:,2)*[0 0 0 1]';
aux_pos(:,2)=i_T(:,:,1)*i_T(:,:,2)*i_T(:,:,3)*[0 0 0 1]';
aux_pos(:,3)=i_T(:,:,1)*i_T(:,:,2)*i_T(:,:,3)*i_T(:,:,4)*i_T(:,:,5)*...
    i_T(:,:,6)*i_T(:,:,7)*[0 0 0 1]';
aux_pos(:,4)=i_T(:,:,1)*i_T(:,:,2)*i_T(:,:,3)*i_T(:,:,4)*i_T(:,:,5)*...
    i_T(:,:,6)*i_T(:,:,7)*i_T(:,:,8)*i_T(:,:,9)*[0 0 0 1]';

for i=1:4
	final_pos(:,i) = aux_pos(1:3,i);
    disp(final_pos(:,i));
end
end

function T = transform(params_i)
% Matriz de transformacao entre a moldura i e i-1

T = [     cos(params_i(4))                  -sin(params_i(4))                 0                   params_i(2);
	sin(params_i(4))*cos(params_i(1)) cos(params_i(4))*cos(params_i(1)) -sin(params_i(1)) -sin(params_i(1))*params_i(3);
	sin(params_i(4))*sin(params_i(1)) cos(params_i(4))*sin(params_i(1))  cos(params_i(1))  cos(params_i(1))*params_i(3);
	0                                   0                         0                       1];
end