%% code for step 1
close all;
clear all;

%% parameters
N = 128; % number of subcarriers
fc = 2e9; % carrier frequency
deltaf = 15e3; % subcarrier spacing
L = 32; % prefix length
indexK = []; %[0 N/2 + (-5:5) ]; % position of null tones
K = length(indexK); % number of null tones

%% generate symbols
N_symbols = (N-K)*1e3;
tx_symbols = floor(4*rand(1,N_symbols));

%4QAM modulation
s = qammodBis(tx_symbols,2,2); 

%% ofdm modulation
x = ofdmmod(s,N,L,K,indexK);
x = x/(x*x'/N_symbols);

% pulse shaping
M = 10; % oversampling factor
x_L = upsample(x,M);
alpha = 0.2;
N_truncated = 10;
u = rcosdesign(alpha,N_truncated,M,'sqrt');
Cuu = conv(u,flip(u));

%% channel
c = 1; % perfect channel

% discrete channel
h = conv(c,Cuu);

% noise free signal
r_nf_L = conv(h,x_L);
r_nf = downsample(r_nf_L,M);

% delete convolution delay
r_nf = r_nf(1+N_truncated:end-N_truncated);

% snr simulations
N_SNR = 6;
SNR = linspace(2,12,N_SNR);
Es_N0 = 10.^(SNR/10);
SER = zeros(1,N_SNR);
for i = 1:N_SNR
    %% generate noise
    noise = (randn(1,length(x)) + 1i*randn(1,length(x)))/sqrt(2);
    nu = N/(N+L)*sqrt((Es_N0(i))^-1)*noise; %((N-K)/(N+L))
    
    % received signal
    r = r_nf + nu;
    
    %% ofdm demodulation
    s_estimated = ofdmdemod(r,N,L,K,indexK);
    
    rx_symbols = qamdemodBis(s_estimated,2,2); %4QAM demod
    SER(i) = sum(rx_symbols ~= tx_symbols)/N_symbols;
    
    % constellation plot
    figure(1);
    subplot(2,3,i);
    plot(s_estimated,'o','markeredgecolor',[0;0;0],...
        'markerfacecolor',[0.5;0.7;1],'markersize',3);
    title(sprintf('SNR = %d [dB]',SNR(i)));
    axis square;
    grid on;
end
%% theoretical BER curve
SER_th = erfc(sqrt(Es_N0/2));

%% BER plot
figure(2);
semilogy(SNR,SER_th,'-r','linewidth',1.5); hold on;
semilogy(SNR,SER,'xb','linewidth',1.5);
grid on;
xlabel('Es_N0');
ylabel('SER');
legend('theory','simulation');