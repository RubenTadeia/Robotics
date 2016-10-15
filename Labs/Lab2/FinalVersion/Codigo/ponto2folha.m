function[ folha ] = ponto2folha ( arvore, ponto )

% Recebe uma árvoree um ponto e devolve a folha qu contém esse ponto

if arvore.filhos==0
   if pertencefolha(ponto,arvore)==1
       folha=arvore;
   end
else if pertencefolha(ponto,arvore.filho1)==1
        folha=ponto2folha(arvore.filho1,ponto);
    else if pertencefolha(ponto,arvore.filho2)==1
            folha=ponto2folha(arvore.filho2,ponto);
        else if pertencefolha(ponto,arvore.filho3)==1
                folha=ponto2folha(arvore.filho3,ponto);
            else if pertencefolha(ponto,arvore.filho4)==1
                    folha=ponto2folha(arvore.filho4,ponto);
                end
            end
        end
    end

end
end



function[ r ] = pertencefolha( ponto, folha )

if folha.local(1)<=ponto(1)&&ponto(1)<folha.local(1)+folha.size && folha.local(2)<=ponto(2)&&ponto(2)<folha.local(2)+folha.size
    r=1;
else r=0;

end
end


