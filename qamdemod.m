function b = qamdemod(s,M)
    if (M==4)
        b = zeros(1,length(s));
        for i = 1:length(b)
            if real(s(i))>0
                if imag(s(i))>0
                    b(i) = 0;
                else
                    b(i) = 3;
                end
            else
                if imag(s(i))>0
                    b(i) = 1;
                else
                    b(i) = 2;
                end
            end
        end
    else 
        error('not 4QAM\n');
    end
end
