function[arvore,fps] = freepoints(mapa)

% função que analisa o mapa e cria a árvore e a estrutura de pontos médios
% e respectivo grafo que vai ser utilizado na pesquisa

arvore=quadrados(mapa);

v=vfp(arvore,[]);

%criar estrutura
s=size(v);
for i=1:s(1)
   fps(i).freepoint=v(i,:);
   f=ponto2folha(arvore,v(i,:));
   fps(i).adjacentes=fronteira(f,arvore);
end
end



function[v] = vfp(arvore, v)

if arvore.valor==1
    v=[v; arvore.medio];
elseif arvore.valor==2 && arvore.size>5
    v=vfp(arvore.filho1,v);
    v=vfp(arvore.filho2,v);
    v=vfp(arvore.filho3,v);
    v=vfp(arvore.filho4,v);
end

end


function[ v ] = fronteira (folha, arvore)

v=[];
j=folha.local(2)-1;
for i=folha.local(1)-1:folha.local(1)+folha.size
    f=ponto2folha(arvore,[i j]);
    if pertencev(f.medio,v)==0 && f.valor==1
        v=[v; f.medio];
    end
end

j=folha.local(2)+folha.size;
for i=folha.local(1)-1:folha.local(1)+folha.size
    f=ponto2folha(arvore,[i j]);
    if pertencev(f.medio,v)==0 && f.valor==1
        v=[v; f.medio];
    end
end

j=folha.local(1)-1;
for i=folha.local(2)-1:folha.local(2)+folha.size
    f=ponto2folha(arvore,[j i]);
    if pertencev(f.medio,v)==0 && f.valor==1
        v=[v; f.medio];
    end
end

j=folha.local(1)+folha.size;
for i=folha.local(2)-1:folha.local(2)+folha.size
    f=ponto2folha(arvore,[j i]);
    if pertencev(f.medio,v)==0 && f.valor==1
        v=[v; f.medio];
    end
end

end


function[ r ] = pertencev( p, v )
s=size(v);
if s(1)==0 && s(2)==0
    r=0;return;
end
for i=1:s(1)
   if p==v(i,:)
       r=1; return;
   else r=0;
   end
end
end