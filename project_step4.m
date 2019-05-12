%% code for step 4
close all;
clearvars;

%rng(0); % TO REMOVE ! JUST FOR DEBUG

%% parameters

% ofdm
N = 128; % number of subcarriers
Lp = 32; % prefix length
indexK = []; %[0 N/2 + (-5:5) ]; % position of null tones
K = length(indexK); % number of null tones

% channel
Lc = 8;
sigma2c = N;

% channel estimation
N_blocks_training = 2;
paramEstimation.N_blocks = N_blocks_training;
paramEstimation.N = N;
paramEstimation.method = 'ML';
paramEstimation.L = Lc;
paramEstimation.sigma2c = sigma2c;

% equalization
paramEqualize.N = N;

%% generate symbols
% transmitted symbols
N_symbols = (N-K)*10;
bits_nc = floor(2*rand(1,2*N_symbols));
bits_c = floor(2*rand(1,N_symbols));
% non coded 
bits_reshape_nc = reshape(bits_nc,2,N_symbols);
tx_symbols_nc  = bits_reshape_nc(1,:)+2*bits_reshape_nc(2,:);
% coded
bits_reshape_c = viterbicod(bits_c);
tx_symbols_c = bits_reshape_c(1,:)+2*bits_reshape_c(2,:);

% training sequence
training = repmat((-1).^(0:N-1),1,paramEstimation.N_blocks);

% 4QAM modulation
s_nc = [training qammodBis(tx_symbols_nc,2,2)];
s_c = [training qammod4(tx_symbols_c)];

%% ofdm modulation
x_nc = ofdmmod(s_nc,N,Lp,K,indexK);
x_c = ofdmmod(s_c,N,Lp,K,indexK);
% pulse shaping
M = 10; % oversampling factor
x_nc_L = upsample(x_nc,M);
x_c_L = upsample(x_c,M);

alpha = 0.2;
N_truncated = 20;
u = rcosdesign(alpha,N_truncated,M,'sqrt');
Cuu = conv(u,flip(u));
Eu = u*u';

% snr simulations
N_SNR = 11;
SNR = linspace(0,20,N_SNR);
Es_N0 = 10.^(SNR/10);
Trials = 500;
[SER_nc,SER_c] = deal(zeros(Trials,N_SNR));

for i = 1:N_SNR
    fprintf('SNR = %d\n',SNR(i));
    for j = 1:Trials
        fprintf('Trial = %d\n',j);
        %% 8-tap rayleigh channel
        %test = [1 0.3 -0.2 0 0 0 0 0.5];
        %test = test/sqrt(test*test');
        %perfect = [1 0 0 0 0 0 0 0];
        c = sqrt(sigma2c)*(randn(1,Lc)+1i*randn(1,Lc))/sqrt(2*Lc); % rayleigh channel
        c_L = upsample(c,M);
        Ec = c_L*c_L';
        h = conv(c_L,Cuu)/sqrt(sigma2c);% same energy convolution
        
        % noise free signal
        r_nf_nc_L = conv(h,x_nc_L);
        r_nf_nc = downsample(r_nf_nc_L(1+(length(Cuu)-1)/2:(length(Cuu)-1)/2+length(x_nc_L)),M);
        
        r_nf_c_L = conv(h,x_c_L);
        r_nf_c = downsample(r_nf_c_L(1+(length(Cuu)-1)/2:(length(Cuu)-1)/2+length(x_c_L)),M);
        
        %% generate noise
        noise_nc = (randn(1,length(r_nf_nc)) + 1i*randn(1,length(r_nf_nc)))/sqrt(2);
        noise_c = (randn(1,length(r_nf_c)) + 1i*randn(1,length(r_nf_c)))/sqrt(2);
        
        sigma2n = 1/(Es_N0(i));
        paramEstimation.sigma2n = sigma2n;
        paramEqualize.sigma2n = sigma2n;
        nu_nc = sqrt(sigma2n)*noise_nc; %((N-K)/(N+L))
        nu_c = sqrt(sigma2n)*noise_c;
        
        % received signal
        r_nc = r_nf_nc + nu_nc;
        r_c = r_nf_c + nu_c;
        
        %% channel estimation
        % extract training sequence
        r_training_nc = r_nc(1:(N+Lp)*N_blocks_training);
        s_training_nc = ofdmdemod(r_training_nc,N,Lp,K,indexK,1);
        c_est_nc = estimateChannel(training,s_training_nc,paramEstimation);
        MSE_nc = 1/Lc*((c-c_est_nc)*(c-c_est_nc)');
        r_nc = r_nc(1+(N+Lp)*N_blocks_training:end);
        
        r_training_c = r_c(1:(N+Lp)*N_blocks_training);
        s_training_c = ofdmdemod(r_training_c,N,Lp,K,indexK,1);
        c_est_c = estimateChannel(training,s_training_c,paramEstimation);
        MSE_c = 1/Lc*((c-c_est_c)*(c-c_est_c)');
        r_c = r_c(1+(N+Lp)*N_blocks_training:end);
        
        %% ofdm demodulation
        s_not_eq_nc = ofdmdemod(r_nc,N,Lp,K,indexK,0);
        s_not_eq_c = ofdmdemod(r_c,N,Lp,K,indexK,0);
        
        %% equalization
        paramEqualize.method = 'ZF';
        [s_eq_nc] = equalize(s_not_eq_nc,c,paramEqualize);
        rx_symbols_nc = qamdemodBis(s_eq_nc,2,2);
        
        [s_eq_c,E] = equalize(s_not_eq_c,c,paramEqualize);
        rx_symbols_c_soft = qamdemod4soft(s_eq_c);
        rx_symbols_c = viterbidecodsoft(rx_symbols_c_soft.',c_est_nc,E,sigma2n,N,1,1);
        
        %% SER computation
        SER_nc(j,i) = sum(rx_symbols_nc ~= tx_symbols_nc)/N_symbols;
        SER_c(j,i) = sum(rx_symbols_c ~= bits_c)/N_symbols;
    end
end
SER_nc = mean(SER_nc);
SER_c = mean(SER_c);
%% theoretical BER curve
SER_th1 = erfc(sqrt(Es_N0/2));
SER_th2 = 1-sqrt((Es_N0/2)./(Es_N0/2+1));

%% BER plot
figure;
semilogy(SNR,SER_th1,'--r','linewidth',1.5,'displayname','awgn'); hold on;
semilogy(SNR,SER_th2,'--k','linewidth',1.5,'displayname','rayleigh'); hold on;
semilogy(SNR,SER_nc,'x-b','linewidth',1.5,'displayname','non coded');
semilogy(SNR,SER_c,'x-g','linewidth',1.5,'displayname','coded - test');
ylim([1e-6 1]);
grid on;
xlabel('Es/N0');
ylabel('SER');
legend('location','best');