function [ yy,xx ,ppx,ppy] = interpolation( varargin )
%INTERPOLATION função que recebe os pontos viários, o número de pontos na
%trajectória interpolada e opcionalmente  tipo de interpolação a fazer e
%devolve a trajectória interpolada.
%Modo 1 é o predefenido e é o pchip, o modo 2 é spline
%   Detailed explanation goes here

if nargin==2
    pathpts=varargin{1};
    mode=1;
    pts=varargin{2};
elseif nargin==3
    pathpts=varargin{1};
    mode=varargin{2};
    pts=varargin{3};
end

if mode==1
    x=pathpts(:,1);
    y=pathpts(:,2);
    t=linspace(0,1000,length(x));
    ppx=pchip(t,x);
    xx = ppval(ppx, linspace(0,1000,pts));
    ppy=pchip(t,y);
    yy = ppval(ppy, linspace(0,1000,pts));
else
    
    x=pathpts(:,1);
    y=pathpts(:,2);
    t=linspace(0,1000,length(x));
    ppx=spline(t,x);
    xx = ppval(ppx, linspace(0,1000,pts));
    ppy=spline(t,y);
    yy = ppval(ppy, linspace(0,1000,pts));
end
end

