function [ map ] = quadrados( mapa )
%QUADRADOS Função que pega num mapa e cria a árvore com a ramificação do
%mapa em que cada folha contém informação sobre localização no mapa,
%tamanho do quadrado, ponto médio, estado de ocupação e descêncencia
%   Detailed explanation goes here

map.quadrado=mapa;
map.pai=[];
s=size(mapa);
map.size=s(1);
map.local=[1 1];
map.medio=[map.local(1)+map.size/2-1 map.local(2)+map.size/2-1];
map.valor=ocupacao(map.quadrado,map.size);
map=expande(map);

end

function [ f ] = expande( folha )
%QUADRADOS Expandir uma folha e criar descendência
%   Detailed explanation goes here
f=folha;
if folha.valor==2 && folha.size>5
    f=filhos(folha);
    f.filhos=1;
   
else f.filhos=0;
end
end

function[ f ] = filhos (pai)

f=pai;
s=size(pai.quadrado);
ap=s(1);
af=fix(ap/2);

filho1.quadrado=pai.quadrado(1:af,1:af);
filho2.quadrado=pai.quadrado(af+1:ap,1:af);
filho3.quadrado=pai.quadrado(1:af,af+1:ap);
filho4.quadrado=pai.quadrado(af+1:ap,af+1:ap);

filho1.pai=pai;
filho2.pai=pai;
filho3.pai=pai;
filho4.pai=pai;

filho1.size=af;
filho2.size=af;
filho3.size=af;
filho4.size=af;

filho1.local=pai.local;
filho2.local=pai.local+[af 0];
filho3.local=pai.local+[0 af];
filho4.local=pai.local+[af af];

filho1.medio=[filho1.local(1)+filho1.size/2-1 filho1.local(2)+filho1.size/2-1];
filho2.medio=[filho2.local(1)+filho2.size/2-1 filho2.local(2)+filho2.size/2-1];
filho3.medio=[filho3.local(1)+filho3.size/2-1 filho3.local(2)+filho3.size/2-1];
filho4.medio=[filho4.local(1)+filho4.size/2-1 filho4.local(2)+filho4.size/2-1];

filho1.valor=ocupacao(filho1.quadrado,filho1.size);
filho2.valor=ocupacao(filho2.quadrado,filho2.size);
filho3.valor=ocupacao(filho3.quadrado,filho3.size);
filho4.valor=ocupacao(filho4.quadrado,filho4.size);

f.filho1=expande(filho1);
f.filho2=expande(filho2);
f.filho3=expande(filho3);
f.filho4=expande(filho4);

end

function[ val ] = ocupacao( quadrado, aresta )
if sum(sum(quadrado))==0
    val=0;
elseif sum(sum(quadrado))==aresta^2
    val=1;
else val=2;
end
end