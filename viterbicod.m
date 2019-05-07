function out = viterbicod(in)
inbis=[0 0 in];
out=zeros(1,2*length(in));
for i=1:(length(inbis)-2)
    out(2*i-1)=mod((inbis(i+2)+inbis(i+1)),2);
    out(2*i)=mod((inbis(i+2)+inbis(i+1)+inbis(i)),2);
end

end
