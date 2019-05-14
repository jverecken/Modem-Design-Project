%% test viterbi
close all;
clearvars;

    N = 10;
    uTrue = [0 0 1 0 0 1 0 1 1 1];
    c = zeros(1,N);
    E = ones(1,N);
    sigma2n = 1;
    c(1) = N;
    hard = 1;
    knowledge = 0;
    y = viterbicod(uTrue);
    
    y = (y*2-1)/sqrt(2);
    
    uDecoded = viterbidecodsoft(y',...
                c,E,sigma2n,N,hard,knowledge);
    
