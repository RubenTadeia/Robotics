function [via] = get_path(p0,pf,v);

mapa=imread('mapa.bmp');


figure(1),
imshow(mapa);hold on;
plot(p0(2),p0(1),'o');
plot(pf(2),pf(1),'og'); legend('Posição inicial','Posição final')
hold off;
pause(0.001);


for i=1:640
    for j=1:640
        if ((i < 145) && (j >= 190)) || ((j>=500)) || (i > 493) || ((i > 187) && (j <= 147)) || ((j>=184 && j < 320) && (i>200 && i <320 ) )
           
            mapa(i,j)=0;
        end
    end
end
figure(4),
imshow(mapa)
map1 = double(mapa);
s =size(map1);
mapa = ~mapa;

[ map n node_info ] = DECOMPOSE([ 1 s(1) 1 s(2) ],zeros(s(1),s(2)),0,[],mapa ,10);

g = BUILD_G(map, n, node_info);

node_path = A_STAR(p0,pf,g,map,n,node_info);
ratio=28500/640;
path = [];
for i=2 :length(node_path)+1
    path = [ path;GET_CENTER(node_path(i - 1),node_info) ];
end

figure(8);
imshow(mapa); hold on;
plot(path(:,2),path(:,1),'.-');hold off;


figure(6);
imagesc(map);
map1(map1 == 0) = 1000000;
map1 = imgaussfilt(map1,10);




figure(5);
imagesc(map1);

map_reg = size(map1);




fechada=fechasalas(mapa,p0,pf);
[arvore,fp]=freepoints(fechada);

imshow(fechada); hold on;
for k=1:length(fp)
    plot(fp(k).freepoint(2),fp(k).freepoint(1),'.');
end
pause(0.001);


pathpts=[];
pathpts=pesquisafp( arvore,fp,p0,pf,mapa);

figure(2);
imshow(mapa); hold on;
plot(pathpts(:,2),pathpts(:,1),'.-');hold off;

pause(0.001);

ratio=28500/640;

path_real=[];
for k=1:length(pathpts);
    path_real(k,:)=ratio*(pathpts(k,:)-p0);
end

[y,x,ppx,ppy]=interpolation(path_real,1,10000);
via=transpose([x;y]);
end