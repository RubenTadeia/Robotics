function [ output_args ] = pathfollow_virt_ang( path, v,dt, start, err )
%PATHFOLLOW_VIRT_ANG Função que simula o seguimento de trajectória
%virtualmente com latência entre comunicações dt.
%   Detailed explanation goes here

 theta=atan2(path(2,2)-path(1,2),path(2,1)-path(1,1))
 w=0
 percorrido = [];
 
 x=path(1,1);
 y=path(1,2);
 ref=1;

figure,
noise=v/100;

    while ref~=length(path)

        ref=nearestpt(x,y,path,ref)
        if ref==length(path)
            
            break
        end
        xref=path(ref,1);
        yref=path(ref,2);
        
        percorrido=[percorrido;x y theta];
        thetaref=atan2(1000*(path(ref+1,2)-yref),1000*(path(ref+1,1)-xref));
        if ref==1
            dtheta=0;
        else dtheta=thetaref-atan2(1000*(yref-path(ref-1,2)),1000*(xref-path(ref-1,1)));
        end
        wref=dtheta*v/sqrt((path(ref+1,1)-path(ref,1))^2+(path(ref+1,2)-path(ref,2))^2)

        eWF=[xref-x;
            yref-y;
            thetaref-theta];


        eB=[cos(theta) sin(theta) 0;
            -sin(theta) cos(theta) 0;
            0 0 1]*eWF;

        adjust=(eB(3)*2*0.1*sqrt(wref^2+0.005*v^2)+0.005*eB(2)*2);
        if abs(adjust)>0.3
             adjust=0.3*sign(adjust)
        end

        w=wref+adjust
    %     w=wref 

        for t=1:5

            theta=theta+w*dt+0.001*randn(1);
            if theta<-pi
                theta=theta+2*pi;
            elseif theta>pi
                theta=theta-2*pi;
            end

            x=x+v*cos(theta)*dt+noise*v/50*randn(1);
            y=y+v*sin(theta)*dt+noise*randn(1);


        end

        plot(path(:,1),path(:,2));hold on;
        plot(x,y,'o');
        plot([x;x+3*cos(theta)],[y;y+3*sin(theta)]);
        plot(xref,yref,'marker','o','color','r');hold off;
        pause(0.01);


    end
    
end


function[imin]=nearestpt(x,y,path,ref);

imin=ref+1;
min=(path(1,1)-x)^2+(path(1,2)-y)^2;

if ref < length(path)/2 
    for i=ref:length(path)/2;
        if min>(path(i,1)-x)^2+(path(i,2)-y)^2;
            min=(path(i,1)-x)^2+(path(i,2)-y)^2;
            imin=i+1;
        end
    end
else
    for i=ref:length(path);
        if min>(path(i,1)-x)^2+(path(i,2)-y)^2;
            min=(path(i,1)-x)^2+(path(i,2)-y)^2;
            imin=i+1;
        end
    end       
end
if imin > length(path)
    imin = length(path);
end
end