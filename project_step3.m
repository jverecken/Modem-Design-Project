%% code for step 3
close all;
clearvars;

%% parameters
N = 128; % number of subcarriers
L = 8; % length of the channel coefficients

M = 100; % number of trials
SNR = linspace(0,20,11); % db
Es_N0 = 10.^(SNR/10); % noise power
N_SNR = length(Es_N0);
mse = zeros(N_SNR,M);


for N_blocks=1:6 % number of blocks of training sequence
    I = repmat((-1).^(0:N-1)',N_blocks,1); % training sequence
    W = repmat(dftmtx(N),N_blocks,1); % dft matrix
    for i=1:N_SNR
        for j=1:M
            % channel
            hTrue = 1/sqrt(2)*(randn(L,1)+1i*randn(L,1));
            hTrue = hTrue/norm(hTrue);
            lambda = repmat(fft(hTrue,N),N_blocks,1);
            
            % noise
            noise = sqrt((Es_N0(i)).^-1)*(randn(N_blocks*N,1)+1i*randn(N_blocks*N,1));
            
            % received signal
            r = lambda.*I+noise;
            
            % ML estimator
            A = (I.*W(:,1:L));
            hEst = A\r;
            
            mse(i,j) = (hTrue-hEst(1:L))'*(hTrue-hEst(1:L));
        end
    end
    mse = mean(mse,2);
    
    semilogy(SNR,mse,'.-','linewidth',1.2,'markersize',15); hold on;
    xlabel('SNR [dB]');
    ylabel('MSE');
    label{N_blocks}=sprintf('%d blocks',N_blocks);
end
title(sprintf('%d-taps normalised Rayleigh channel\naveraged on %d trials',L,M));
legend(label);
grid on;

