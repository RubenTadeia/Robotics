function [ via_1 ] = Real_test( p0,pf,real,v )
%REAL_TEST A funçao Real_test é semelhante à interface criada e é o resumo
%de todo o projecto.
% Recebe uma posição inicial e final, um valor chamado real que permite
% começar a simulação de seguida ou apenas calcular a trajectória para usar
% na funçao pathfollow e a velocidade caso seja pretendido começar a
% simulação de imediato.
%   Detailed explanation goes here

% Leitura do ficheiro mapa
global rob;
mapa=imread('mapa.bmp');

for i=1:640
    for j=1:640
        
        if ((i < 145) && (j >= 190)) || ((j>=500)) || (i > 493) || ((i > 187) && (j <= 147)) || ((j>=184 && j < 320) && (i>200 && i <320 ) )   
            mapa(i,j)=0;
        end
    end
end

for i=1:640
    for j=1:640
     if((i>=145) && (i <= 493)) && ((j == 500) || (j == 501) || (j == 502))
         mapa(i,j) = 1;
     end
    end
end


checkpt_1 = [319 164];
checkpt_2 = [475 323];
checkpt_3 = [320 483];
checkpt_4 = [164 323];


% Exibição de figura com o mapa, posição inicial e final.
figure(1),
imshow(mapa);hold on;
plot(p0(2),p0(1),'o');
plot(pf(2),pf(1),'og');
plot(checkpt_1(2), checkpt_1(1),'o');
plot(checkpt_2(2), checkpt_2(1),'o');
plot(checkpt_3(2), checkpt_3(1),'o');
plot(checkpt_4(2), checkpt_4(1),'o');legend('Posição inicial','Posição final','troço_1','troço_2','troço_3','troço_4' )
hold off;
pause(0.001);



% Fechar salas desnecessárias e criação de grafo e árvore.
fechada=fechasalas(mapa,p0,pf);
[arvore,fp]=freepoints(fechada);

% Exibição dos pontos livres

% figure(2);

imshow(mapa); hold on;
for k=1:length(fp)
    plot(fp(k).freepoint(2),fp(k).freepoint(1),'.');
end
pause(0.001);


% Algoritmo de pesquisa e criação de pontos viários

pathpts=pesquisafp( arvore,fp,p0,checkpt_1,mapa);

pathpts_1 = [pesquisafp( arvore,fp,checkpt_1,checkpt_2,mapa)];
pathpts_2 = [pesquisafp( arvore,fp,checkpt_2,checkpt_3,mapa)];
pathpts_3 = [pesquisafp( arvore,fp,checkpt_3,checkpt_4,mapa)];
pathpts_4 = [pesquisafp( arvore,fp,checkpt_4,p0,mapa)];




pause(0.001);

imshow(mapa); hold on;
plot(pathpts(:,2),pathpts(:,1),'.-');
plot(pathpts_1(:,2),pathpts_1(:,1),'.-');
plot(pathpts_2(:,2),pathpts_2(:,1),'.-');
plot(pathpts_3(:,2),pathpts_3(:,1),'.-');
plot(pathpts_4(:,2),pathpts_4(:,1),'.-');
hold off;

ratio=15800/348 ;

pathpts_hall = [pathpts_1;pathpts_2;pathpts_3];
% Interpolação e exibição no mapa
[y1,x1,ppx,ppy]=interpolation(pathpts,1,10000);
[y4,x4,ppx,ppy]=interpolation(pathpts_hall,1,10000);
[y5,x5,ppx,ppy]=interpolation(pathpts_4,1,10000);



% Conversão para unidades reais

for k=1:length(pathpts(:,1));
    path_real_1(k,:)=ratio*(pathpts(k,:) - p0);
end

for k=1:length(pathpts_hall(:,1));
    path_real_hall(k,:)=ratio*(pathpts_hall(k,:) - p0);
end
for k=1:length(pathpts_4(:,1));
    path_real_5(k,:)=ratio*(pathpts_4(k,:) - p0);
end

[y1,x1,ppx,ppy]=interpolation(path_real_1,1,10000);
[y4,x4,ppx,ppy]=interpolation(path_real_hall,1,10000);
[y5,x5,ppx,ppy]=interpolation(path_real_5,1,10000);


figure(5);
hold on;
plot(y1,x1);
plot(y4,x4);
plot(y5,x5);
hold off;


    
via_1 = transpose([x1;y1]);
via_2 = transpose([x4;y4]);
via_3 = transpose([x5;y5]);

% pathfollow_virt_ang(via_1,10,1,1,0);
% pathfollow_virt_ang(via_2,10,1,0, 0);
% pathfollow_virt_ang(via_3,10,1,0, 0);

real=1;
% Ínicio de simulação caso pretendido
if real==1
 rob=serial_port_start('COM4');
pioneer_init(rob);  
    
[percorrid visto error] = pathfollow_real_ang(via_1,100,1,0);
[percorrid visto error] = pathfollow_real_ang(via_2,100,1,error);
[percorrid visto error] = pathfollow_real_ang(via_3,100,1,error);

pioneer_close(rob);

end

end

