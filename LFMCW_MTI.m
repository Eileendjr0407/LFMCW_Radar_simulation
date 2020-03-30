clear all;clc;
f0=2.4e9;
B=10e6;
c=3e8;
lamda=c/f0;
SNR=15;%�����
T=0.5e-3;%�ϡ���ɨƵ����
u=B/T;
M=32;%����������
fs=20e6;%����Ƶ��
r=c*(1/fs)/2
fre=1000;               %�״��ظ�Ƶ��
PRT=1/fre;            %�״��ظ�����
tao_max=0.3e-3;   %Ŀ������ӳ�
R_s=1800;               %��ֹĿ�����
R_move=[3200,6000,8000];%Ŀ�����
V=[150,220,300];%Ŀ���ٶ�
fd=2*V/lamda;
N=1024;
% t=linspace(-T,T,N);
t=0:1/fs:T;
N=length(t);
tao=2*R_move/c;
signal_m=zeros(M,N);
%Ŀ��ز�����
for k=1:M
    for m=1:length(R_move)
        x(m,:)=exp(1j*2*pi*(u*tao(m)+fd(m)-u*(2*V(m)*k*PRT/c)*t-fd(m)*k*PRT+f0*tao(m)));      %  the signal from the returned signal 
    end
    signal_m(k,:)=sum(x);
    clear x;
end
signal_m=awgn(signal_m,SNR);
signal_m_fft=fft(signal_m);
figure;plot(abs(signal_m_fft(1,:)));

signal_s=zeros(M,N);
tao0=2*R_s/c;
for k=1:M
    %signal_s(k,:)=cos(u*(tao+k*T));
    signal_s(k,:)=cos(f0*(tao0+k*PRT)+u*(tao0+k*PRT)*t-1/2*u*((tao0+k*PRT)^2));
end
signal=signal_m+signal_s;

signal=signal_m;
signal=awgn(signal,SNR);
figure;
plot((1:N),real(signal(1,:)));
signal_fft=fft(signal(1,:),4096);
figure 
plot(abs(signal_fft)/max(abs(signal_fft)));

% figure;
% plot((0:N-1),abs(signal_fft(1,:)));

