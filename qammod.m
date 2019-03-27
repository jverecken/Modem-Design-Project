% b : input signal between 0 and M-1
% M : number of symbols in the qam (power of 2)
% s : output complex signal

function s = qammod(b,M)
    if (M==4)
        s = zeros(1,length(b));
        sym = [1+1i;
              -1+1i;
              -1-1i;
               1-1i];
        for i = 1:length(b)
            s(i) = sym(b(i)+1);
        end
    else 
        error('not 4QAM\n');
    end
end
