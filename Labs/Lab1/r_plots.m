function [] = r_plots( final_pos,T,in )
%R_PLOTS Simula graficamente em 3D e 2D
%   R_PLOTS(FINAL_POS,T,in) FINAL_POS - o vector com as posicoes
%   cartesianas de cada ponto do robot após simulação.
%                              T - Matriz de Transformacao do efector no
%                              world frame
%                              in - Coeficiente de abertura da garra
%   Constroi graficos 3D e 2D para se poderem anasilar os resultados.

global C
%% PLOT 3D
figure(1);

drawnow; clf; hold on;
subplot(2,2,1);title('Plot 3D');xlabel('X/mm');ylabel('Y/mm');zlabel('Z/mm');
axis([-3 5 -4 4 -1 7]*100)
view(3)

% BASE
vect_base = [20 20 -100 -100 20 20 -100 -100;
    -80 80 -80 80 -80 80 -80 80;
    0 0 0 0 40 40 40 40];

for i=1:8
    for j=i+1:8
        line([vect_base(1,i) vect_base(1,j)],[vect_base(2,i) vect_base(2,j)],[vect_base(3,i) vect_base(3,j)],'Marker','.','LineStyle','-');
    end
end

% ROBOT
line([0 0],[0 0],[40 99],'Marker','.','LineStyle','-');
line([0 final_pos(1,1)],[0 final_pos(2,1)],[99 final_pos(3,1)],'Marker','.','LineStyle','-');
line([final_pos(1,1) final_pos(1,2)],[final_pos(2,1) final_pos(2,2)],[final_pos(3,1) final_pos(3,2)],'Marker','.','LineStyle','-');
line([final_pos(1,2) final_pos(1,3)],[final_pos(2,2) final_pos(2,3)],[final_pos(3,2) final_pos(3,3)],'Marker','.','LineStyle','-');
line([final_pos(1,3) final_pos(1,4)],[final_pos(2,3) final_pos(2,4)],[final_pos(3,3) final_pos(3,4)],'Marker','.','LineStyle',':','Color','r');

%Gripper

hold off

%% PLOTS 2D

X=[0 0 final_pos(1,1) final_pos(1,2) final_pos(1,3) final_pos(1,4)];
Y=[0 0 final_pos(2,1) final_pos(2,2) final_pos(2,3) final_pos(2,4)];
Z=[0 99 final_pos(3,1) final_pos(3,2) final_pos(3,3) final_pos(3,4)];

subplot(2,2,2);plot(X,Z,'.-');title('Vista Lateral');xlabel('X/mm');ylabel('Z/mm');axis([-220 480 0 700]);
subplot(2,2,3);plot(X,Y,'.-');title('Vista Superior');xlabel('X/mm');ylabel('Y/mm');axis([-220 480 -350 350]);
subplot(2,2,4); plot(Y,Z,'.-');title('Vista Frontal');xlabel('Y/mm');ylabel('Z/mm'); axis([-350 350 0 700]);

end

