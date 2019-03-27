close all;
clear all;
rng(0);

%% parameters
N = 128; % number of subcarriers
fc = 2e9; % carrier frequency
deltaf = 15e3; % subcarrier spacing
L = 16; % prefix length

%% generate symbols
N_symbols = 128*1e3;
tx_symbols = floor(4*rand(1,N_symbols));
s = qammod(tx_symbols,4)/sqrt(2); %4QAM modulation

%% ofdm modulation
% ofdm symbols
tx_blocks = reshape(s,[floor(N_symbols/N),N]);
ofdm_symbols = sqrt(N)*ifft(tx_blocks,N,2);

%cyclic prefix
ofdm_symbols_with_prefix = [ofdm_symbols(:,end-(L-1):end) ofdm_symbols];

x = reshape(ofdm_symbols_with_prefix,[1,numel(ofdm_symbols_with_prefix)]);

% pulse shaping
M = 10; % oversampling factor
x_L = upsample(x,M);
alpha = 0.2;
N_truncated = 10;
u = rcosdesign(alpha,N_truncated,M,'sqrt');
Cuu = conv(u,flip(u));

%% channel
c = 1; % perfect boiii

% discrete channel
h = conv(c,Cuu);

% noise free signal
r_nf_L = conv(h,x_L);
r_nf = downsample(r_nf_L,M);
r_nf = r_nf(1+N_truncated:end-N_truncated);

% snr simulations
N_SNR = 8;
SNR = linspace(1,12,N_SNR);
Es_N0 = 10.^(SNR/10);
SER = zeros(1,N_SNR);
for i = 1:N_SNR
    %% generate noise
    noise = (randn(1,length(x)) + 1i*randn(1,length(x)))/sqrt(2);
    nu = (Es_N0(i))^-1*noise;
    
    % received signal
    r = r_nf + nu;
    
    %% ofdm demodulation
    % serial 2 parallel
    r_ofdm_symbols_with_prefix = reshape(r,[floor(length(r)/(N+L)),N+L]);
    
    % remove prefix
    r_ofdm_symbols = r_ofdm_symbols_with_prefix(:,L+1:end);
    
    r_blocks = 1/sqrt(N)*fft(r_ofdm_symbols,N,2);
    
    % parallel 2 serial
    s_estimated = reshape(r_blocks,[1,numel(r_blocks)]);
    
    rx_symbols = qamdemod(s_estimated*sqrt(2),4); %4QAM demod
    SER(i) = sum(rx_symbols ~= tx_symbols)/N_symbols;
end
%% theoretical BER curve
SER_th = erfc(sqrt(Es_N0/2));

%% constellation plot
figure;
plot(s_estimated,'.r','markersize',12);
axis square;

%% BER plot
figure;
semilogy(SNR,SER_th,'-r'); hold on;
semilogy(SNR,SER,'xb','markersize',12);