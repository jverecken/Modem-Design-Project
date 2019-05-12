close all;
clearvars;

N_SNR = 11;
SNR = linspace(0,20,N_SNR);

load('SER_awgn_TH');
load('SER_rayleigh_TH');
load('SER_rayleigh_NC_ZF');
load('SER_rayleigh_C_ZF');
load('SER_rayleigh_NC_MMSE');
load('SER_rayleigh_C_MMSE');
load('SER_rayleigh_NC_ZF_TRUEC');
load('SER_rayleigh_C_ZF_TRUEC');

colors = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.4940 0.1840 0.5560;
    0.4660 0.6740 0.1880];

figure;
semilogy(SNR,SER_awgn_TH,'-r','linewidth',1.5,'displayname','awgn'); hold on;
semilogy(SNR,SER_rayleigh_TH,'-k','linewidth',1.5,'displayname','rayleigh');
semilogy(SNR,SER_rayleigh_NC_ZF_TRUEC,'.-','Color',[0 1 1],'linewidth',1.5,'markersize',15,'displayname','ZF - true channel - not coded');
semilogy(SNR,SER_rayleigh_C_ZF_TRUEC,'.-','Color',[0 1 0],'linewidth',1.5,'markersize',15,'displayname','ZF - true channel - coded');
semilogy(SNR,SER_rayleigh_NC_ZF,'.:','Color',colors(1,:),'linewidth',1.5,'markersize',15,'displayname','ZF - not coded');
semilogy(SNR,SER_rayleigh_C_ZF,'.:','Color',colors(2,:),'linewidth',1.5,'markersize',15,'displayname','ZF - coded');
semilogy(SNR,SER_rayleigh_NC_MMSE,'.:','Color',colors(3,:),'linewidth',1.5,'markersize',15,'displayname','MMSE - not coded');
semilogy(SNR,SER_rayleigh_C_MMSE,'.:','Color',colors(4,:),'linewidth',1.5,'markersize',15,'displayname','MMSE - coded');
ylim([1e-6 1]);
grid on;
xlabel('Es/N0 [dB]');
ylabel('SER');
legend('location','best');
title(sprintf('OFDM - 8 taps Rayleigh channel\nEqualization - Convolutional coding'));