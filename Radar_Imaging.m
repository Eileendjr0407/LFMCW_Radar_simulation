clear all;clc;close all;
% R=[10,40,42];    % Ŀ��ľ��룻
% V=[10,-50,-53];         %  Ŀ����ٶȣ�   m/s
% Theta=[-30,10,50];�״��ϵͳ��
load('data_cube');
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
data_PreImaging=fftshift(fft(signal_mtd,128,3),3);
data_Imaging=reshape(data_PreImaging(43,:,:),[512,128]);
figure
Angle_Range=asind([-63:1:64]*lambda/(d*L));
Distance_Range=[1:512];
imagesc(Distance_Range,Angle_Range,abs(data_Imaging)');
colormap('jet');colorbar;
set(gca,'YDir','normal');xlabel('Distance');ylabel('Angle');
% figure
xx=reshape(data_PreImaging(43,83,:),[1,128]);
figure
plot(Angle_Range,abs(xx));
figure
data=data_PreImaging(1,:,:);
data_imaging_matrix=reshape(sum(abs(data_PreImaging),1),[512,128]);
figure
imagesc(Distance_Range,Angle_Range,abs(data_imaging_matrix)');
%% 
% data_preImaging=reshape(signal_Pc(1,:,:),[512,128]);
% figure;
% imagesc(abs(data_preImaging).');
% colormap('jet');colorbar;
% set(gca,'YDir','normal');xlabel('Distance');ylabel('The number of antenna');
% data_Imaging=fftshift(fft(data_preImaging,128,2),2);
% figure
% Angle_Range=asind([-63:1:64]*lambda/(d*L));
% Distance_Range=[1:512];
% imagesc(Distance_Range,Angle_Range,abs(data_Imaging).');
% colormap('jet');colorbar;
% set(gca,'YDir','normal');xlabel('Distance');ylabel('Angle');
