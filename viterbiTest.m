%% test viterbi
close all;
clearvars;

y = [0 0;
     1 1;
     0 0;
     1 0;
     1 0;
     1 1;
     0 1;
     1 1;
     0 0];
 
y = (y*2-1)/sqrt(2);
 
u = viterbi(y,ones(length(y(:,1)),1));
