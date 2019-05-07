function [out] = viterbidecod(in)
inbis=zeros(2,length(in)/2);

for i=1:length(in)
    if mod(i,2)==0
        inbis(2,i/2)=in(i);
    else
        inbis(1,(i+1)/2)=in(i);
    end
end

out=zeros(1,length(in)/2);
p = zeros(4,length(out)+2);
e = zeros(4,1);
p(1,1:4) =[0 0 0 0];
p(2,1:4) =[0 0 0 1];
p(3,1:4) =[0 0 1 0];
p(4,1:4) =[0 0 1 1];
e(1)=erreur(p(1,:),3,inbis(:,1))+erreur(p(1,:),4,inbis(:,2));
e(2)=erreur(p(2,:),3,inbis(:,1))+erreur(p(2,:),4,inbis(:,2));
e(3)=erreur(p(3,:),3,inbis(:,1))+erreur(p(3,:),4,inbis(:,2));
e(4)=erreur(p(4,:),3,inbis(:,1))+erreur(p(4,:),4,inbis(:,2));

for i=3:length(out)
    e0=zeros(1,4);
    e1=zeros(1,4);
    pnext = zeros(4,length(out)+2);
    for j=1:4
       e0(j)=e(j)+erreur(p(j,:),i+2,inbis(:,i));
       p(j,i+2)=1;
       e1(j)=e(j)+erreur(p(j,:),i+2,inbis(:,i));
    end

    if(e0(1)<e0(3))
       pnext(1,:)=p(1,:);
       pnext(1,i+2)=0;
       e(1)=e0(1);
    else
        pnext(1,:)=p(3,:);
        pnext(1,i+2)=0;
        e(1)=e0(3);
    end
    
    if(e0(2)<e0(4))
       pnext(3,:)=p(2,:);
       pnext(3,i+2)=0;
       e(3)=e0(2);
    else
        pnext(3,:)=p(4,:);
        pnext(3,i+2)=0;
        e(3)=e0(4);
    end
    
    if(e1(2)<e1(4))
       pnext(4,:)=p(2,:);
       pnext(4,i+2)=1;
       e(4)=e1(2);
    else
       pnext(4,:)=p(4,:);
       pnext(4,i+2)=1;
       e(4)=e1(4);
    end
    
    if(e1(1)<e1(3))
       pnext(2,:)=p(1,:);
       pnext(2,i+2)=1;
       e(2)=e1(1);
    else
       pnext(2,:)=p(3,:);
       pnext(2,i+2)=1;
       e(2)=e1(3);
    end
    
    
    p=pnext;
end
[n index]=min(sum(e,2));
out=p(index,3:end);

    
end

function [e] = erreur(x,i,y)
    y1=mod((x(i)+x(i-1)),2);
    y2=mod((x(i)+x(i-1)+x(i-2)),2);
    e=0;
    if(y1~=y(1))
        e=e+1;
    end
    if(y2~=y(2))
        e=e+1;
    end
end

function [ns] =nextstate(s,i)
    r=mod(s,2);
    ns=2*r+i;
end
