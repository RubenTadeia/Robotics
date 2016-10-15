function g = BUILD_G(map,n,node_info)

g = zeros(n);
s = size(map);

for i = 1:n
    
    aux = 0;
    
    m_i = node_info(i,1);
    m_f = node_info(i,2);
    n_i = node_info(i,3);
    n_f = node_info(i,4);
    
    if m_i > 1
        
        for j = n_i:n_f
            
            if aux(end) ~= map((m_i - 1),j) && map((m_i - 1),j) ~= 0
                
                aux = [ aux map((m_i - 1),j) ];
                
            end
            
        end
        
    end
        
    if m_f < s(1)
        
        for j = n_i:n_f
            
            if aux(end) ~= map((m_f + 1),j) && map((m_f + 1),j) ~= 0
                
                aux = [ aux map((m_f + 1),j) ];
                
            end
            
        end
        
    end
    
    if n_i > 1
        
        for j = m_i:m_f
            
            if aux(end) ~= map(j,(n_i - 1)) && map(j,(n_i - 1)) ~= 0
                
                aux = [ aux map(j,(n_i - 1)) ];
                
            end
            
        end
        
    end
    
    if n_f < s(2)
        
        for j = m_i:m_f
            
            if aux(end) ~= map(j,(n_f + 1)) && map(j,(n_f + 1)) ~= 0
                
                aux = [ aux map(j,(n_f + 1)) ];
                
            end
            
        end
        
    end
    
    aux(1) = [];
    
    for k = 1:length(aux)
        
        g(i,aux(k)) = 1;
        
    end
    
end

end