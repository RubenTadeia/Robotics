
function [ via_1 ] = lap_test( )
load('mapa.mat');



path = [130 70;
    155 85;
    155 95;
    162.5 132.5;
    185 165;
    215 165;
    265 165;
    315 165;
    365 165;
    415 165;
    455 165;
    475 185;
    475 235;
    475 285;
    475 335;
    475 385;
    475 435;
    475 455;
    455 485;
    405 485;
    355 485;
    305 485;
    255 485;
    205 485;
    185 485;
    165 455;
    165 405;
    165 355;
    165 305;
    165 255;
    165 205;
    165 166;
    162.5 132.5;
    155 95;
    155 85;
    130 70;];


% path = [185 165;
%     215 165;
%     265 165;
%     315 165;
%     365 165;
%     415 165;
%     455 165;
%     475 185;
%     475 235;
%     475 285;
%     475 335;
%     475 385;
%     475 435;
%     475 455;
%     455 485;
%     405 485;
%     355 485;
%     305 485;
%     255 485;
%     205 485;
%     185 485;
%     165 455;
%     165 405;
%     165 355;
%     165 305;
%     165 255;
%     165 205;
%     165 166;
%     162.5 132.5;
%     155 95;
%     155 85;
%     130 70;];
p0 = path(1);

figure(5);
imshow(mapa); hold on;
plot(path(:,2),path(:,1),'.-');
pause(0.001);hold off;

[y,x,ppx,ppy]=interpolation(path,2,10000);
imshow(mapa);hold on;
plot(y,x);
hold off;

ratio = 15800/348;
p0 = path(1,:)*ratio;
for k=1:length(path(:,1));
    path_real(k,:)=ratio*(path(k,:) - path(1,:));
end


[y,x,ppx,ppy]=interpolation(path_real,2,10000);

via_1 = transpose([x;y]);

end