% Title:  The system of LFMCW Radar
% attenna Arrays:    4*32
% Author: 丁杰如
%Date:    2019-11-24
clear all;clc;close all;
fc=77e9;
j=sqrt(-1);
B=1e9;   
c=3e8;
Fs=1e6;
T=500e-6;        % PRT 
PRF=1/T;
K=B/T;
R=[10,12,9];    % 目标的距离；
V=[10,-50,-53];         %  目标的速度；   m/s
Theta=[9,10,9];
lambda=c/fc;
d=lambda/2;                     %表示振元之间的间距
fd=2*V/lambda;                         %  目标的多普勒频率
SNR=10;                           %       信噪比
L=128;                                    %  其中，L表示振元个数
N=Fs*T;                                 %   表示采样点数
t_n=[1:N]/Fs;
CPN=60;
dn=zeros(CPN,N,L);
Q=length(R);
%%   Generation The Data Cube
for l=0:L-1
    for cpn=1:CPN
        for q=1:Q
%             x(q,:)=exp(2*j*pi*(((2*K*R(q))/c+(2*K*V(q)*cpn*T)/c)*t_n+2*V(q)/lambda*cpn*T+2*fc*R(q)/c+d/lambda*l*sind(Theta(q))));
                   x(q,:)=exp(2*j*pi*(((2*K*R(q))/c)*t_n+2*V(q)/lambda*cpn*T+2*fc*R(q)/c+d/lambda*l*sind(Theta(q))));

        end
        dn(cpn,:,l+1)=sum(x);
        clear x
    end
end
dn=awgn(dn,SNR);
save('Data_cube','dn');
%%    Test code 
signal_Per_Array=dn(:,:,1);
figure;
subplot(211),plot([1:N],real(signal_Per_Array(1,:)));title('real part of ADC data');
signal_Pc=fft(signal_Per_Array,2^(nextpow2(N)),2);
subplot(212);plot([1:512],abs(signal_Pc(1,:)));title(' Pluse Compression data');
figure;
subplot(211);
imagesc(abs(signal_Pc));
colormap('jet');colorbar;
set(gca,'YDir','normal');xlabel('Distance');ylabel('CPN');
signal_mtd=fft(signal_Pc,2^(nextpow2(CPN)));
title('CPN Matrix');
subplot(212)
imagesc(abs(fftshift(signal_mtd,1)));colormap('jet');colorbar;
set(gca,'YDir','normal');xlabel('Distance');ylabel('velocity');
title('RD Matrix');
%%      Signal Processing 
for l=1:L
    N_fft=2^(nextpow2(N));
    signal_Pc(:,:,l)=fft(dn(:,:,l),2^(nextpow2(N)),2);      %  分别给每一路信号做脉冲压缩
    signal_mtd(:,:,l)=fft(signal_Pc(:,:,l),2^(nextpow2(CPN)));     %   分别给每一路信号做MTD
end
save('Data_mtd','signal_mtd');
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
%% 
