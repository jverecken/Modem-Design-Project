function h_est = estimateChannel(I,r,param)
N        = param.N;
N_blocks = param.N_blocks;
L        = param.L;
sigma2c   = param.sigma2c;
sigma2n    = param.sigma2n;
method   = param.method;

I = I.';
r = r.';

W = repmat(dftmtx(N)/sqrt(N),N_blocks,1);
A1 = (I.*W(:,1:L));
% ML estimator
switch method
    case 'ML'
        h_est = (A1\r).'; % automatically solve with LS
    case 'MAP'
        % MAP estimator with knowledge of noise power and h distr
        A2 = [A1;sqrt((sigma2n)/(sigma2c))*eye(L)];
        h_est = (A2\[r;zeros(L,1)]).';
end
end