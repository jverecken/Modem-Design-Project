function x = ofdmmod(s,N,L,K,indexK)
% ofdm symbols
N_symbols = length(s);
N_blocks = floor((N_symbols)/(N-K));
tx_blocks = reshape(s,[N_blocks,N-K]);
kjjj
% add null tones
for k=1:K
    tx_blocks = cat(2,tx_blocks(:,1:indexK(k)),...
                zeros(N_blocks,1),...
                tx_blocks(:,indexK(k)+1:end));
end

% ifft with constant energy on each row
ofdm_symbols = sqrt(N)*ifft(tx_blocks,N,2);

% add cyclic prefix
ofdm_symbols_with_prefix = [ofdm_symbols(:,end-(L-1):end) ofdm_symbols];

x = reshape(ofdm_symbols_with_prefix,[1,N_symbols+N_blocks*(L+K)]);
