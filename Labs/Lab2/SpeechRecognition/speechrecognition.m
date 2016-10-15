function speechrecognition(filename)
%Speech Recognition Using Correlation Method
%Write Following Command On Command Window 
%speechrecognition('test.wav')
voice=wavread(filename);
x=voice;
x=x';
x=x(1,:);
x=x';
y1=wavread('one.wav');
y1=y1';
y1=y1(1,:);
y1=y1';
z1=xcorr(x,y1);
m1=max(z1);
l1=length(z1);
t1=-((l1-1)/2):1:((l1-1)/2);
t1=t1';
%subplot(3,2,1);
plot(t1,z1);
y2=wavread('two.wav');
y2=y2';
y2=y2(1,:);
y2=y2';
z2=xcorr(x,y2);
m2=max(z2);
l2=length(z2);
t2=-((l2-1)/2):1:((l2-1)/2);
t2=t2';
%subplot(3,2,2);
figure
plot(t2,z2);
y3=wavread('three.wav');
y3=y3';
y3=y3(1,:);
y3=y3';
z3=xcorr(x,y3);
m3=max(z3);
l3=length(z3);
t3=-((l3-1)/2):1:((l3-1)/2);
t3=t3';
%subplot(3,2,3);
figure
plot(t3,z3);
y4=wavread('four.wav');
y4=y4';
y4=y4(1,:);
y4=y4';
z4=xcorr(x,y4);
m4=max(z4);
l4=length(z4);
t4=-((l4-1)/2):1:((l4-1)/2);
t4=t4';
%subplot(3,2,4);
figure
plot(t4,z4);
y5=wavread('five.wav');
y5=y5';
y5=y5(1,:);
y5=y5';
z5=xcorr(x,y5);
m5=max(z5);
l5=length(z5);
t5=-((l5-1)/2):1:((l5-1)/2);
t5=t5';
%subplot(3,2,5);
figure
plot(t5,z5);
m6=300;
a=[m1 m2 m3 m4 m5 m6];
m=max(a);
h=wavread('allow.wav');
if m<=m1
    soundsc(wavread('one.wav'),50000)
        soundsc(h,50000)
elseif m<=m2
    soundsc(wavread('two.wav'),50000)
        soundsc(h,50000)
elseif m<=m3
    soundsc(wavread('three.wav'),50000)
        soundsc(h,50000)
elseif m<=m4
    soundsc(wavread('four.wav'),50000)
        soundsc(h,50000)
elseif m<m5
    soundsc(wavread('five.wav'),50000)
        soundsc(h,50000)
else soundsc(wavread('denied.wav'),50000)
   
end