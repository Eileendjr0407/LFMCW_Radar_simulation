% Target information:
% R=[10,40,42];    % Ŀ��ľ��룻
% V=[10,-50,-53];         %  Ŀ����ٶȣ�   m/s
% Theta=[-30,10,50];�״��ϵͳ��
clear all;clc;close all;
load('Data_cube');
N=500;
CPN=60;
L=128;
c=3e8;
Fc=77e9;
lambda=c/Fc;
d=lambda/2;
for l=1:L
    N_fft=2^(nextpow2(N));
    signal_Pc(:,:,l)=fft(dn(:,:,l),2^(nextpow2(N)),2);      %  �ֱ��ÿһ·�ź�������ѹ��
    signal_mtd(:,:,l)=fft(signal_Pc(:,:,l),2^(nextpow2(CPN)));     %   �ֱ��ÿһ·�ź���MTD
end
xx_3=fftshift(fft(reshape(signal_mtd(58,62,:),[1 L])));
xx_2=fftshift(fft(reshape(signal_mtd(43,83,:),[1 L])));
xx_1=fftshift(fft(reshape(signal_mtd(5,69,:),[1 L])));
figure
plot([-63:1:64],abs(xx_1),'-r');
hold on 
plot([-63:1:64],abs(xx_2),'k');
hold on
plot([-63:1:64],abs(xx_3),'b');grid on;
hold off;
legend('Target_1','Target_2','Target_3');
disp('*******************Bearing Information of Targets******************************');
S=[11,12,11];
Theta_Estimation=asind(S*lambda/(d*L))