function [ output_args ] = Inverse_Kinematics( input_args,eul )

%Posição do end-effector
p_x = input_args(1);
p_y = input_args(2);
p_z = input_args(3);
output_args = [];

%Orientação do end-effector
% Angulos de Euler
alpha = eul(1);
beta = eul(2);
gama = eul(3);


eul = [degtorad(alpha),degtorad(beta), degtorad(gama)];
% Conversão dos angulos de Euler numa matriz de rotação
rotm = eul2rotm(eul,'ZYZ');
disp(rotm);

%Coordenadas de posição
pos = [input_args(1) input_args(2) input_args(3)];

%Posição da junta 5
pos_junta_5 = pos - 30*rotm(:,3)';

%Inicialização de um vector de ângulos a 0
angs=zeros(1,6);

%calculo do angulo nº3 duas soluçoes

sw = pos_junta_5(3)-99;

c3 = (pos_junta_5(1)^2 + pos_junta_5(2)^2 + sw^2 -120^2 -147^2)/(2*120*147);
s3_1 = sqrt(1 - c3^2);
s3_2 = - s3_1;

angs(3)= radtodeg(atan2(s3_1,c3));
teta3_1 = radtodeg(atan2(s3_1,c3));
teta3_2 = radtodeg(atan2(s3_2,c3));

% calculo do angulo nº 2 quatro soluçoes
c2_1_1 = (sqrt(pos_junta_5(1)^2+pos_junta_5(2)^2)*(120 + 147*c3) + ...
    sw*147*s3_1)/(120^2 + 147^2 +2*120*147*c3);
c2_2_1 = (-1*sqrt(pos_junta_5(1)^2+pos_junta_5(2)^2)*(120 + 147*c3) + ...
    sw*147*s3_1)/(120^2 + 147^2 +2*120*147*c3);

c2_1_2 = (sqrt(pos_junta_5(1)^2+pos_junta_5(2)^2)*(120 + 147*c3) + ...
    sw*147*s3_2)/(120^2 + 147^2 +2*120*147*c3);
c2_2_2 = (-1*sqrt(pos_junta_5(1)^2+pos_junta_5(2)^2)*(120 + 147*c3) + ...
    sw*147*s3_2)/(120^2 + 147^2 +2*120*147*c3);

s2_1_1 = ((sqrt(pos_junta_5(1)^2+pos_junta_5(2)^2)*147*s3_1 + ...
    sw*(147*c3 + 120)))/(120^2 + 147^2 +2*120*147*c3);
s2_2_1 = ((-1*sqrt(pos_junta_5(1)^2+pos_junta_5(2)^2)*147*s3_1 + ...
    sw*(147*c3 + 120)))/(120^2 + 147^2 +2*120*147*c3);

s2_1_2 = ((sqrt(pos_junta_5(1)^2+pos_junta_5(2)^2)*147*s3_2 + ...
    sw*(147*c3 + 120)))/(120^2 + 147^2 +2*120*147*c3);
s2_2_2 = ((-1*sqrt(pos_junta_5(1)^2+pos_junta_5(2)^2)*147*s3_2 + ...
    sw*(147*c3 + 120)))/(120^2 + 147^2 +2*120*147*c3);

% Estas soluções podem ser coincidentes ou não
angs(2)= - radtodeg(atan2(s2_2_1,c2_1_1));
%Teta 2 solução 1 a 4
teta_2_1 = - radtodeg(atan2(s2_1_1,c2_2_1));
teta_2_2 = - radtodeg(atan2(s2_2_1,c2_1_1));
teta_2_3 = - radtodeg(atan2(s2_2_2,c2_1_2));
teta_2_4 = - radtodeg(atan2(s2_1_2,c2_2_2));

%Calculo do teta 1 duas soluçoes
angs(1)= radtodeg(atan2(pos_junta_5(2), pos_junta_5(1)));
%Teta 1 solução 1
teta1_1 = radtodeg(atan2(pos_junta_5(2), pos_junta_5(1)));
%Teta 1 solução 2
teta1_2 = radtodeg(atan2(- pos_junta_5(2), - pos_junta_5(1)));


%Cálculo dos tetas do pulso
D_H = [  pi/2        0      0    angs(1)*pi/180;
		  0      120   0  angs(2)*pi/180;
		0       147    0     angs(3)*pi/180];
      
         
i_T=zeros(4,4,3);
T_0_5=eye(4);

for i=1:3
	i_T(:,:,i)=transform(D_H(i,:));
	T_0_5=T_0_5*i_T(:,:,i);
end

R_0_5 = T_0_5(1:3,1:3);

R_5_6 = R_0_5'*rotm;

% Cálculo do Teta 4
angs(4) = radtodeg(atan2(R_5_6(2,3), R_5_6(1,3)));

% Cálculo do Teta 5
l_x_5 = p_x - pos_junta_5(1);
l_y_5 = p_y - pos_junta_5(2);
l_z_5 = p_z - pos_junta_5(3);


z_5 = sqrt((l_z_5)^2+(l_y_5)^2)*sin(3*pi/2);
angs(5) = radtodeg(atan2(z_5, l_x_5));



function T = transform(params_i)
% Matriz de transformacao entre a moldura i e i-1

T = [     cos(params_i(4))                  -sin(params_i(4))                 0                   params_i(2);
	sin(params_i(4))*cos(params_i(1)) cos(params_i(4))*cos(params_i(1)) -sin(params_i(1)) -sin(params_i(1))*params_i(3);
	sin(params_i(4))*sin(params_i(1)) cos(params_i(4))*sin(params_i(1))  cos(params_i(1))  cos(params_i(1))*params_i(3);
	0                                   0                         0                       1];
end




end

