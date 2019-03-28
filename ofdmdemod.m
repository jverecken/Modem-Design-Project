function s = ofdmdemod(r,N,L,K,indexK)
% serial 2 parallel
N_blocks = floor(length(r)/(N+L));
r_ofdm_symbols_with_prefix = reshape(r,[N_blocks,N+L]);

% remove prefix
r_ofdm_symbols = r_ofdm_symbols_with_prefix(:,L+1:end);

% fft with constant energy on each row
r_blocks = 1/sqrt(N)*fft(r_ofdm_symbols,N,2);

% remove null tones
for k=1:K
    r_blocks = cat(2,r_blocks(:,1:indexK(K-(k-1))),...
               r_blocks(:,indexK(K-(k-1))+2:end));
end

% parallel 2 serial
s = reshape(r_blocks,[1,(N-K)*N_blocks]);