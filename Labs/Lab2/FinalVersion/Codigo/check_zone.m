function [ zone ] = check_zone( x , y, ratio)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

pixel_x = x/ratio;
pixel_y = y/ratio;

if pixel_x >= 184 && pixel_x <= 454 && pixel_y <= 184
    zone = 1;
    return 
end

if pixel_x >= 454 && pixel_y >= 184 && pixel_y <= 468
    zone = 2;
    return 
end

if pixel_x >= 184 && pixel_x <= 454 && pixel_y >= 468
    zone = 3;
    return 
end
zone = 0;
if pixel_x <= 184 && pixel_y >= 184 && pixel_y <= 468
    zone = 4;
    return 
end

end

