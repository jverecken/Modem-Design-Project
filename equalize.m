function [s_hat,E] = equalize(s,c,paramEqualize)
N = paramEqualize.N;
method = paramEqualize.method;
sigma2n = paramEqualize.sigma2n;
N_blocks = size(s,1);

lambda = 1/sqrt(N)*fft(c,N);

switch method
    case 'ZF'
        E = 1./lambda;
    case 'MMSE'
        E = (conj(lambda)./(lambda.*conj(lambda) + sigma2n));
end
s_blocks = E.*s;
s_hat = reshape(s_blocks.',[1,N*N_blocks]);

end