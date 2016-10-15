function [ percorrido,visto] = pathfollow_real_ang(path, v )
%PATHFOLLOW_REAL_ANG Função que recebe a porta série e trajectória a ser
%seguida e segue-a com velocidade v.
%   Detailed explanation goes here

% Orientar o robot na direcção do primeiro troço
global rob;

theta=fix(atan2(path(2,2)-path(1,2),path(2,1)-path(1,1))*360/2/pi)
pioneer_set_heading(rob,theta);
pause(3)

% Inicialização de contantes
percorrido=[]
visto=[]
ref=1;
K=v/100;  % Factor escala, uma vez que foi testado a v=100 este factor permite usar as mesmas contantes para qualquer v

w=0;
pioneer_set_controls(rob,v,w);

integrated_error=0;

passo=0;



figure,
while ref~=length(path)
    
    
    passo=passo+1;
    
    % Localização através de odomtria.
    q=pioneer_read_odometry;
    x=q(1);
    y=q(2); 
    thetareal=q(3);
    thetareal=fix(thetareal*360/4096);
    if thetareal>180
        thetareal=thetareal-360
    else thetareal
    end
    percorrido=[percorrido;x y thetareal];
    
    vision=pioneer_read_sonars;
    if length(vision)==20
        visto=[visto;vision];
    else visto=[visto;ones(1,8)*5000];
    end
    
    
    % Procurar ponto de referência e caso seja o último ponto da
    % trajectória aborta a navegação. Caso contrário calcula velocidade
    % angular de referência.
    
    ref=nearestpt(x,y,path,ref);
    if ref==length(path)
        pioneer_close(rob);
        break
    end
    
    
    xref=path(ref,1);
    yref=path(ref,2);
    thetaref=atan2(1000*(path(ref+1,2)-yref),1000*(path(ref+1,1)-xref))*360/2/pi;
    if ref==1
        dtheta=0;
    else dtheta=thetaref-atan2(1000*(yref-path(ref-1,2)),1000*(xref-path(ref-1,1)))*360/2/pi;
    end
    
   
    
    wref=dtheta*v/sqrt((path(ref+1,1)-path(ref,1))^2+(path(ref+1,2)-path(ref,2))^2)
    
    % Cálculo dos erros de orientação e posição
    
    theta_err=thetaref-thetareal;
    
    if theta_err<-180
        theta_err=theta_err+360;
    elseif theta_err>180
        theta_err=theta_err-360;
    end
    
    
    eWF=[xref-x;
        yref-y;
        theta_err];
    
    eB=[cos(thetaref) sin(thetaref) 0;
        -sin(thetaref) cos(thetaref) 0;
        0 0 1]*eWF;
    
    
    %Cálculo dos ajustes aos erros
    
    integrated_error=0.5*integrated_error+eB(2);
    
    qsi=0.1;
    
    b=0.0005;
    
     
    adjust_eb2=b*v*integrated_error*K;
    
    if abs(adjust_eb2)>30
        adjust_eb2=30*sign(adjust_eb2);
    end
    
    
    adjust_eb3=eB(3)*2*qsi*sqrt(wref^2+abs(b)*v^2)*K;
    if abs(adjust_eb3)>15
        adjust_eb3=15*sign(adjust_eb3);
    end
    
    vision=[5000 5000 5000 5000 5000 5000 5000 5000];
    angles=[90 50 30 10 -10 -30 -50 -90];
    
    
    
    adjust_vision=0;
    too_close=0;
    
    
    status=[0 0 0 0];
    % Verificação da proximidade nos sonares laterais
    
    %sonares de 90 graus
    
    if vision(1)<175
        status(1)=2;
    elseif vision(1)<250
        status(1)=1;
    end
    
    if vision(8)<175
        status(4)=2;
    elseif vision(8)<250
        status(4)=1;
    end
    
    %sonares de 50 graus
    
    if vision(2)<200
        status(2)=2;
        adjust_vision=adjust_vision-(135-abs(angles(2)))*(300-vision(2))
    elseif vision(2)<300
        status(2)=1;
    end
    
    if vision(7)<200
        status(3)=2;
        adjust_vision=adjust_vision+(135-abs(angles(7)))*(300-vision(7));
    elseif vision(7)<300
        status(3)=1;
    end
    
        
    % Cálculo do ajuste da visão baseado nos 4 sonares frontais
    for i=3:6
        if vision(i)<300&&too_close~=2
            if vision(i)<100
                too_close=2;
            elseif too_close==0
                too_close=1;
            end
            
        end
        if vision(i)<500
            if i<5 adjust_vision=adjust_vision-(135-abs(angles(i)))*(500-vision(i));
            else adjust_vision=adjust_vision+(135-abs(angles(i)))*(500-vision(i));
            end
        end
    end
    
    adjust_vision=adjust_vision/4000*K*10
    
    % Estabelecer hierarquia entre e2 e e3
    
    if abs(adjust_eb2)>15*K
        adjust_eb3=adjust_eb3*0.3
    end
    
    % Estalecer hierarquai para ajuste dos sonares em relação aos outros.
    if abs(adjust_vision)>15*K
        adjust_eb3=0.3*adjust_eb3;
        adjust_eb2=0.3*adjust_eb2;
    end
    
    adjust_eb2;
    adjust_eb3;
    w=fix(wref+adjust_eb3+adjust_eb2+adjust_vision)
    
    % Código que impede o robot de virar para um lado caso os sonares
    % laterais apresentem leituras muito próximas
    
    if (status(1)==2||status(1)==1||status(2)==1)&& w>0
        w=0;
    elseif (status(4)==2||status(4)==1||status(3)==1)&& w<0
        w=0;
    end
    
    % Estabelecer limite máximo para velocidade angular dada ao robot
    
    if abs(w)>45
        w=45*sign(w);
    end
    
    % Alteração da velocidade caso haja objectos muito próximos.
    vision
     mini=min(vision);
    
   vreal=v;
   
   if too_close==2
       vreal=fix(v/4)
   elseif too_close==1;
       vreal=fix(v/2)
   end
    
    pioneer_set_controls(rob,vreal,w);
      
    % Ciclo que mostra as trajectórias e as leituras de sonar a cada 10
    % ciclos.
    if passo==10
        passo=0;
        
        subplot(1,2,1)
        plot(path(:,1),path(:,2));hold on;
        plot(x,y,'o');
        plot(percorrido(:,1),percorrido(:,2),'.g');
        plot(xref,yref,'marker','o','color','r');hold off;
        
        
        % Método para mostrar os sonares só até 500 mm
        for i=1:8
            if vision(i)>500
                vision(i)=500;
            end
        end
        
        subplot(1,2,2)
        polar(angles*2*pi/360,vision(1:8));
        
        
        pause(0.001)
    end
        
end

end


function[imin]=nearestpt(x,y,path,ref);

imin=1;
min=(path(1,1)-x)^2+(path(1,2)-y)^2;

if (ref + length(path)/2) < length(path) 
    for i=ref:length(path)/2;
        if min>(path(i,1)-x)^2+(path(i,2)-y)^2;
            min=(path(i,1)-x)^2+(path(i,2)-y)^2;
            imin=i;
        end
    end
else
    for i=ref:length(path);
        if min>(path(i,1)-x)^2+(path(i,2)-y)^2;
            min=(path(i,1)-x)^2+(path(i,2)-y)^2;
            imin=i;
        end
    end       
end
min
end
    
    
    