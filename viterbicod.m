function out = viterbicod(in)
inbis=[0 0 in];
out=zeros(length(in),2);
for i=1:(length(inbis)-2)
    out(i,1)=mod((inbis(i+2)+inbis(i+1)),2);
    out(i,2)=mod((inbis(i+2)+inbis(i+1)+inbis(i)),2);
end

end
