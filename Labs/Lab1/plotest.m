function [] = plotest( final_pos , n_outs, valid)
%R_PLOTS Simula graficamente em 3D e 2D
%   R_PLOTS(FINAL_POS,T,in) FINAL_POS - o vector com as posicoes
%   cartesianas de cada ponto do robot após simulação.
%   Constroi graficos 2D para se poderem anasilar os resultados.

%% PLOTS 2D
figure(2);

for i=1:n_outs
    if valid(i)
        X(i,:)=[0 0 final_pos(1,1,i) final_pos(1,2,i) final_pos(1,3,i)];
        Z(i,:)=[0 275 final_pos(3,1,i) final_pos(3,2,i) final_pos(3,3,i)];
    end
end

plot(X',Z');title('Todas as solucoes encontradas');xlabel('X/mm');ylabel('Z/mm');axis([-220 480 0 700]);


end