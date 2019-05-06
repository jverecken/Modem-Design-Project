%% code for step 3
close all;
clearvars;

%% parameters
N = 128; % number of subcarriers
L = 8; % length of the channel coefficients

M = 1000; % number of trials
SNR = linspace(0,10,21); % db
Es_N0 = 10.^(SNR/10); % noise power
N_SNR = length(Es_N0);
mseML = zeros(N_SNR,M);
mseMAP = zeros(N_SNR,M);

sigma2 = 1/(2*L);


for N_blocks=1:6 % number of blocks of training sequence
    I = repmat((-1).^(0:N-1)',N_blocks,1); % training sequence
    W = repmat(dftmtx(N),N_blocks,1); % dft matrix
    for i=1:N_SNR
        for j=1:M
            % channel
            hTrue = sqrt(sigma2)*(randn(L,1)+1i*randn(L,1));
            lambda = repmat(fft(hTrue,N),N_blocks,1);
            
            % noise
            noise = sqrt((Es_N0(i)).^-1)*(randn(N_blocks*N,1)+1i*randn(N_blocks*N,1));
            
            % received signal
            r = lambda.*I+noise;
            
            % ML estimator
            A1 = (I.*W(:,1:L));
            hEstML = A1\r; % automatically solve with LS
            
            % MAP estimator with knowledge of noise power and h distr
            A2 = [A1;sqrt((Es_N0(i)^-1)/(sigma2))*eye(L)];
            hEstMAP = A2\[r;zeros(L,1)];
            
            mseML(i,j) = (hTrue-hEstML(1:L))'*(hTrue-hEstML(1:L));
            mseMAP(i,j) = (hTrue-hEstMAP(1:L))'*(hTrue-hEstMAP(1:L));
        end
    end
    mseML = mean(mseML,2);
    mseMAP = mean(mseMAP,2);
    
    semilogy(SNR,mseML,'.-','linewidth',1.2,'markersize',15); hold on;
    semilogy(SNR,mseMAP,'.--','linewidth',1.2,'markersize',15); hold on;
    xlabel('SNR [dB]');
    ylabel('MSE');
    label{2*N_blocks-1}=sprintf('%d blocks ML',N_blocks);
    label{2*N_blocks}=sprintf('%d blocks MAP',N_blocks);
end
title(sprintf('%d-taps normalised Rayleigh channel\naveraged on %d trials',L,M));
legend(label);
grid on;

