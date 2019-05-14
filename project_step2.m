%% code for step 2
close all;
clearvars;

capacity = 0;
mse_zf = 1;
mse_mse = 0;

%% parameters
% ofdm
N = 128; % number of subcarriers

% channel
load('CIR.mat'); % channel response of energy 1
lambda = fft(h,N); % power of each channel

% bit loading
Pmax = N*1; % max power is the uniform repartition power N*sigma_I^2
pe_target = 1e-5;
G = Gamma(pe_target);
SNR = [0 10 20];
N_SNR = length(SNR);
Es_N0 = 10.^(SNR/10); % in db

[sigma2xk,sigma2nk] = deal(N_SNR,N);

%% optimize capacity
if capacity
    tol = 1e-3*Pmax;
    itermax = 1e5;
    delta = 1e-4*Pmax/N;
    
    bk = zeros(N_SNR,N);
    for i=1:N_SNR
        do = 1;
        iter = 0;
        
        % noise power on each channel
        for k=1:N
            sigma2nk(i,k) = Es_N0(i)^-1 / abs(lambda(k))^2;
        end
        
        mu = (Pmax) / N; % initial guess
        
        % waterfilling algorithm
        while (do)
            for k=1:N
                sigma2xk(i,k) = pospart(mu-sigma2nk(i,k));
            end
            if (abs(sum(sigma2xk(i,:)) - Pmax) > tol && iter < itermax)
                if (sum(sigma2xk(i,:)) < Pmax)
                    mu = mu + delta;
                else
                    mu = mu - delta;
                end
            else
                do = 0;
            end
            iter = iter +1;
        end
        
    end
    
    adaptedSNR = sigma2xk./sigma2nk;
    uniformSNR = Pmax/N*ones(3,N)./sigma2nk;
    adaptedbit = optimalBit(adaptedSNR,G);
    uniformbit = optimalBit(uniformSNR,G);
    for i=1:length(Es_N0)
        % plot
        figure;
        bar([sigma2nk(i,:)' sigma2xk(i,:)'],'stacked','linestyle','none');
        title(sprintf('E_s/N_0 = %d',SNR(i)));
        ylabel('Power');
        figure;
        plot(uniformSNR(i,:),'-b');
        hold on;
        plot(adaptedSNR(i,:),'-r');
        title(sprintf('E_s/N_0 = %d',SNR(i)));
        ylabel('SNR');
        figure;
        plot(uniformbit(i,:),'-b');
        hold on;
        plot(adaptedbit(i,:),'-r');
        title(sprintf('E_s/N_0 = %d',SNR(i)));
        ylabel('Bit');
    end
end

%% Optimize MSE
% Zero forcing
if mse_zf
    for i=1:N_SNR
        for k=1:N
            sigma2nk(i,k) = Es_N0(i)^-1 / abs(lambda(k))^2;
        end
        for k = 1:N
            sigma2xk(i,k) = Pmax./(abs(lambda(k))*sum(1./abs(lambda)));
        end
    end
    adaptedSNR = sigma2xk./sigma2nk;
    uniformSNR = Pmax/N*ones(3,N)./sigma2nk;
    
    figure;
    for i=1:length(Es_N0)
        % plot
        subplot(3,2,2*i-1);
        bar([sigma2nk(i,:)' sigma2xk(i,:)'],'stacked','linestyle','none');
        title(sprintf('E_s/N_0 = %d',SNR(i)));
        xlim([1 128]);
        ylabel('Power');
        legend('Noise','Symbol');
        
        subplot(3,2,2*i);
        plot(uniformSNR(i,:),'-b');
        hold on;
        plot(adaptedSNR(i,:),'-r');
        title(sprintf('E_s/N_0 = %d',SNR(i)));
        xlim([1 128]);
        ylabel('SNR');
        legend('Uniform Energy','Adaptive Energy');
    end
end

% mmse
if mse_mse
    for i=1:N_SNR
        for k=1:N
            sigma2nk(i,k) = Es_N0(i)^-1 / abs(lambda(k))^2;
        end
        for k = 1:N
            sigma2xk(i,k) = (Pmax+sigma2nk(i,k)*sum(1./abs(lambda).^2))./(abs(lambda(k))*sum(1./abs(lambda)))-sigma2nk(i,k)./abs(lambda(k)).^2;
        end
    end
    adaptedSNR = sigma2xk./sigma2nk;
    uniformSNR = Pmax/N*ones(3,N)./sigma2nk;
    for i=1:length(Es_N0)
        % plot
        figure;
        bar([sigma2nk(i,:)' sigma2xk(i,:)'],'stacked','linestyle','none');
        title(sprintf('E_s/N_0 = %d',SNR(i)));
        ylabel('Power');
        figure;
        plot(uniformSNR(i,:),'-b');
        hold on;
        plot(adaptedSNR(i,:),'-r');
        title(sprintf('E_s/N_0 = %d',SNR(i)));
        ylabel('SNR');
    end
end



function b = optimalBit(SNR,G)
b = 1/2*log2(1+SNR./G);
end

function G = Gamma(pe_target)
G = 2/3*(erfcinv(pe_target/2))^2;
end

function res = pospart(x)
res = x.*(x>0);
end