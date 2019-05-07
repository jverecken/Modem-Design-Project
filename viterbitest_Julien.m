%% test viterbi
close all;
clearvars;

for i = 1:50
    uTrue = round(rand(128,1));
    y = viterbicod(uTrue');
    
    y = (y*2-1)/sqrt(2);
    
    uDecoded = viterbidecodsoft(y,ones(length(y(:,1)),1));
    
    error = sum(abs(uTrue-uDecoded));
    if error ~= 0
        fprintf("iter = %d Errors = %d\n",i,error);
    end
end