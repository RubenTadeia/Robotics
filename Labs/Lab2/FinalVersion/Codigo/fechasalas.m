function [ mapout ] = fechasalas( mapa,p0,pf )

% Esta função faz um pré-processamento do mapa e veda o acesso ao robot de
% salas que não vão ser utilizadas durante o procedimento, de forma a
% melhorar a eficiência do algoritmo e evitar trabalho desnecessário.

mapout=mapa;

for i=6:634
    for j=6:634
        if mapa(i,j)==0
            mapout(i-5:i+5,j-5:j+5)=zeros(11,11);
        end
    end
end


end

