% Title:  The system of LFMCW Radar
% attenna Arrays:    4*32
% Author: 丁杰如
%Date:    2019-12-5
clear all;clc;close all;
R_max=210;
Fc=77e9;         %  雷达的载频
B=4e9;           %  雷达的带宽
c=3e8;              %  光速
T=R_max*2/c;
PRF=1/T;
lambda=c/Fc;
v_max=lambda/2*PRF;
Kr=B/T;               %  调频率
Fs=1e9;            %  雷达采样频率 
t=[0:1/Fs:T];
N=length(t);
SNR=5;             % db
CPN=500;
deltaR=c/(2*B);
disp(['发生距离走动的临界速度为:',num2str(deltaR/(CPN*T)),'  m/s']);
R=100;
V=180;
Q=length(R);
%% 
dn=zeros(CPN,N);
for cpn=1:CPN
%      dn(cpn,:)=exp(2*1j*pi*(((2*Kr*R)/c)*t+2*V/lambda*cpn*T+2*Fc*R/c));
%     dn(cpn,:)=exp(2*pi*1j*(Fc*2*(R+V*(cpn*T+t))/c+Kr*2*(R+V*(cpn*T+t))/c.*t-Kr*(2*(R+V*(cpn*T+t))/c).^2/2));
    dn(cpn,:)=exp(2*1j*pi*(((2*Kr*R)/c+(2*Kr*V*cpn*T)/c)*t+2*V/lambda*cpn*T+2*Fc*R/c));
end
dn=awgn(dn,SNR);
figure;
subplot(211)
plot(t,real(dn(1,:)))
legend('real');
subplot(212)
plot(t,imag(dn(1,:)),'r')
legend('imag')
%%  产生了距离走动现象 
signalpc=fft(dn,1500,2);
figure;imagesc(abs(signalpc))
set(gca,'YDir','normal');xlabel('Distance');ylabel('CPN');
colormap('jet');colorbar
signalmtd=fftshift(fft(signalpc,2048));
figure;imagesc(abs(signalmtd))
set(gca,'YDir','normal');xlabel('Distance');ylabel('velocity');
colormap('jet');colorbar
%% 
