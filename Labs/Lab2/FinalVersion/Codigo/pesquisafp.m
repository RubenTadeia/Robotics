function [ resposta] = pesquisa( arvore,freepoints,posIni,posFin,map)
%PESQUISA Algoritmo de pesquisa A* para a partir da árvore e grafo já
%criados encontrar heuristicamente o caminho entre uma posição inicial e
%final dadas.
%   Detailed explanation goes here



folha0=ponto2folha(arvore,posIni);
folhaf=ponto2folha(arvore,posFin);

p0=folha0.medio;
pf=folhaf.medio;


close=zeros(640,640);
open=[newnode(p0,0,pf)];
found=0;
analises=0;
while length(open)~=0&&found~=1
    
    actual=open(1);
    open=open(2:end);
    if actual.pos(1)==pf(1)&&actual.pos(2)==pf(2)
        
        resposta=[];
        while ~isnumeric(actual)
            resposta=[actual.pos; resposta];
            actual=actual.dad;
        end
        resposta=[resposta(1:end-1,:);posFin];
        found=1;
        path=zeros(640,640);
        for i=1:length(resposta)
            path(fix(resposta(i,1)),fix(resposta(i,2)))=-1;
        end
        fprintf('Solução encontrada em %d expansões',analises);
%         figure;imshow(close,[]);
%         figure;imshow(map+path);
        
    else
        
        [open,close]=expandir(open,close,actual,pf,freepoints);
        analises=analises+1;
        fprintf('%d analises  %d  abertos\n',analises,length(open))
            
        
        
    end
    
    
    
end

if p0(1)~=resposta(1,1)||resposta(1,2)~=p0(2);
    resposta=[p0;resposta];
end


end

function [nop]=newnode(position,dad,pf)

% Criação de um nó

nop.pos=position;
if isstruct(dad)
    nop.cost=dad.depth+sqrt((pf(1)-position(1))^2+(pf(2)-position(2))^2);
    if position(1)~=dad.pos(1)&&position(2)~=dad.pos(2)
        nop.depth=dad.depth+sqrt((dad.pos(1)-position(1))^2+(dad.pos(2)-position(2))^2);
    else nop.depth=dad.depth+sqrt((dad.pos(1)-position(1))^2+(dad.pos(2)-position(2))^2);
    end
else  nop.cost=norm(position.*pf);
    nop.depth=0;
end
nop.dad=dad;
end

function [openout,closeout]=expandir(openin,closein,actual,pf,freepoints)

% Função que expande um nó para todas as posições para que ele pode ir.

openout=[];
closeout=[];

closeout=closein;
openout=openin;
p=actual.pos;
adjs=encontrafp(freepoints,p);
adjs=adjs.adjacentes;

if closein(fix(p(1)),fix(p(2)))==0
    
    for i=1:length(adjs)
        
        if closein(fix(adjs(i,1)),fix(adjs(i,2)))==0;
            
            openout=insertopen(openout,newnode([adjs(i,1),adjs(i,2)],actual,pf));
            
            
        end
    end
closeout(fix(p(1)),fix(p(2)))=actual.cost;
end


end



function [openout]=insertopen(openin,no)

% Função que insere heuristicamente o nó nos abertos

openout=[];
openout=openin;
if length(openin)==0
    openout=[no];
else i=1;
    done=0;
    while i<length(openin)&&~done;
        if openin(i).cost>no.cost
            openout=[openin(1:i-1) no openin(i:end)];
            done=1;
        else  i=i+1;
        end
    end
    if ~done
        openout=[openout no];
    end
end
    
end
