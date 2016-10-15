%% <insert title>

%% INIT

clear all; close all;
global rob;

while 42==42
    
    % ------------------------ input -----------------------------
    % usar (3;4.65) metros e (3.5;2) metros por exemplo
    mode = input('Insert mode (1)lap_test (2)trajectory_test : ');
    
    if mode == 2
        p0 = input('Insert inicial point [x y ]: ');
        pf = input('Insert final point [x y ]: ');
        if isempty(p0); p0 = [130 70];end
        if isempty(pf); pf = [475 455]; end
        path = Real_tes2(p0,pf,0);
        
    end
    
    if mode == 1
%         path = lap_test();
    load('path.mat');
    end
    
    sim = input('Insert (1)simulation (2)real : ');
    if isempty(sim); sim = 1;end

    
    if sim == 1
        pathfollow_virt_ang(path,10,1,1,0);
    end
    
    if sim == 2
        rob=serial_port_start('COM4');
        pioneer_init(rob);
        ratio = 15800/348;
        
        p0 = path(1,:)*ratio;
        pathfollow_real_ang(path, 150, 1, 0 ,p0);
        pioner_close();
    end
    
       
end

disp('Thank you for your patience. On a great jorney, we have been.');

% it works!
