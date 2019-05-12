function y = qammod4(x)
    realpart = mod(x,2);
    imagpart = (x-realpart)/2;
    
    y = (2*(realpart-0.5) + 1i*2*(imagpart-0.5))/2;
end