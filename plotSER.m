close all;
clearvars;

N_SNR = 11;
SNR = linspace(0,20,N_SNR);
index = 1:7;

load('SER_awgn_TH');
load('SER_rayleigh_TH');
load('SER_rayleigh_NC_ZF');
load('SER_rayleigh_C_ZF');
load('SER_rayleigh_NC_ZF_TRUEC');
load('SER_rayleigh_C_ZF_TRUEC');

load('SER_rayleigh_NC_MMSE');
load('SER_rayleigh_C_MMSE');

load('SER_rayleigh_C_ZF_NOKNOWLEDGE');
load('SER_rayleigh_C_ZF_HARD_NOKNOWLEDGE');
load('SER_rayleigh_C_ZF_HARD');

colors = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.4940 0.1840 0.5560;
    0.4660 0.6740 0.1880];

figure(1);
semilogy(SNR(index),SER_awgn_TH(index),'-r','linewidth',1.5,'displayname','awgn'); hold on;
semilogy(SNR(index),SER_rayleigh_TH(index),'-k','linewidth',1.5,'displayname','rayleigh');
semilogy(SNR(index),SER_rayleigh_NC_ZF_TRUEC(index),'.-','Color',[0 1 1],'linewidth',1.5,'markersize',15,'displayname','true channel - not coded');
semilogy(SNR(index),SER_rayleigh_C_ZF_TRUEC(index),'.-','Color',[0 1 0],'linewidth',1.5,'markersize',15,'displayname','true channel - coded');
semilogy(SNR(index),SER_rayleigh_NC_ZF(index),'.:','Color',colors(1,:),'linewidth',1.5,'markersize',15,'displayname','estimated channel - not coded');
semilogy(SNR(index),SER_rayleigh_C_ZF(index),'.:','Color',colors(2,:),'linewidth',1.5,'markersize',15,'displayname','estimated channel - coded');
grid on;
%ylim([1e-6 1]);
xlabel('Es/N0 [dB]');
ylabel('SER');
legend('location','best');
title(sprintf('OFDM - 8 taps Rayleigh channel\nZF Equalization - Soft decoding'));
saveas(gcf,'SER_True_Estimated_Channel.png');

figure(2);
semilogy(SNR(index),SER_awgn_TH(index),'-r','linewidth',1.5,'displayname','awgn'); hold on;
semilogy(SNR(index),SER_rayleigh_TH(index),'-k','linewidth',1.5,'displayname','rayleigh');
semilogy(SNR(index),SER_rayleigh_NC_ZF(index),'.-','Color',[0 1 1],'linewidth',1.5,'markersize',15,'displayname','ZF - not coded');
semilogy(SNR(index),SER_rayleigh_C_ZF(index),'.-','Color',[0 1 0],'linewidth',1.5,'markersize',15,'displayname','ZF - coded');
semilogy(SNR(index),SER_rayleigh_NC_MMSE(index),'.:','Color',colors(1,:),'linewidth',1.5,'markersize',15,'displayname','MMSE - not coded');
semilogy(SNR(index),SER_rayleigh_C_MMSE(index),'.:','Color',colors(2,:),'linewidth',1.5,'markersize',15,'displayname','MMSE - coded');
grid on;
%ylim([1e-6 1]);
xlabel('Es/N0 [dB]');
ylabel('SER');
legend('location','best');
title(sprintf('OFDM - 8 taps Rayleigh channel\nEstimated channel - Soft decoding'));
saveas(gcf,'SER_ZF_MMSE_Equalization.png');

figure(3);
semilogy(SNR(index),SER_awgn_TH(index),'-r','linewidth',1.5,'displayname','awgn'); hold on;
semilogy(SNR(index),SER_rayleigh_TH(index),'-k','linewidth',1.5,'displayname','rayleigh');
semilogy(SNR(index),SER_rayleigh_C_ZF(index),'.-','Color',[0 1 1],'linewidth',1.5,'markersize',15,'displayname','soft - channel known');
semilogy(SNR(index),SER_rayleigh_C_ZF_HARD(index),'.-','Color',[0 1 0],'linewidth',1.5,'markersize',15,'displayname','hard - channel known');
semilogy(SNR(index),SER_rayleigh_C_ZF_NOKNOWLEDGE(index),'.:','Color',colors(1,:),'linewidth',1.5,'markersize',15,'displayname','soft - channel not known');
semilogy(SNR(index),SER_rayleigh_C_ZF_HARD_NOKNOWLEDGE(index),'.:','Color',colors(2,:),'linewidth',1.5,'markersize',15,'displayname','hard - channel not known');
grid on;
%ylim([1e-6 1]);
xlabel('Es/N0 [dB]');
ylabel('SER');
legend('location','best');
title(sprintf('OFDM - 8 taps Rayleigh channel\nZF Equalization - Estimated channel'));
saveas(gcf,'SER_Hard_Soft_Decoding_Knowledge.png');
