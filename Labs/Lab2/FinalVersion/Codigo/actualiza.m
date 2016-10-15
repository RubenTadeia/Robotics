function [ mact ] = actualiza( mapa, pos, orientacao, sonar )
%ACTUALIZA Função que recebe a matriz-mapa, posição e postura do robot e
%leitura dos sonares e actualiza o mapa acrescentando o encontrado e
%apagando o que estava errado no mapa.
%   Detailed explanation goes here

mact=mapa;
angles=[-90+orientacao -50+orientacao -30+orientacao -10+orientacao 10+orientacao 30+orientacao 50+orientacao 90+orientacao];

j=8;
l=1;

for i=1:8
   if sonar(i)>3000
       j=j-1;
   else sonar(l)=sonar(i);angles(l)=angles(i);
       l=l+1;
   end
end

pobjs=zeros(2,j);

for i=1:j
    pobjs(1,i)=cos(angles(i)*2*pi/360)*sonar(i)/10;
    pobjs(2,i)=sin(angles(i)*2*pi/360)*sonar(i)/10;
end

for i=1:j
    pobjs(1,i)=fix(pobjs(1,i)*640/2850);
    pobjs(2,i)=fix(pobjs(2,i)*640/2850);
end


for k=1:j
    if sonar(k)<3000
    for p=1:sonar(k)
        posvcm(1)=cos(angles(k)*2*pi/360)*p/10;
        posvcm(2)=sin(angles(k)*2*pi/360)*p/10;
        posvpx(1)=fix(posvcm(1)*640/2850);
        posvpx(2)=fix(posvcm(2)*640/2850);
        mact(pos(1)+posvpx(1)-4:pos(1)+posvpx+4,pos(2)+posvpx(2)-4:pos(2)+posvpx(2)+4)=ones(9);
    end
    end
end
for k=1:j
        px=pobjs(1,k);
        py=pobjs(2,k);
        mact(fix(pos(1)+px),fix(pos(2)+py))=0;
end

end