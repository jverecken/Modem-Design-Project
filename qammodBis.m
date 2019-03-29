%mapps a vector vec of integer values between 1 and n_x*n_y to a vector z
%with complex values in a rectangular constellation of dimension n_x/n_y 
function z = qammodBis(vec,n_x,n_y)
    z=zeros(1,length(vec))
    if(mod(n_x,2)==0)
        x=[-(0.5:1:(n_x/2)) 0.5:1:(n_x/2)];
    else
        x=(1:n_x)-ceil(n_x/2);
    end
    if(mod(n_y,2)==0)
        y=[-(0.5:1:(n_y/2)) 0.5:1:(n_y/2)];
    else
        y=(1:n_y)-ceil(n_y/2);
    end
    y=y'*j;
    m=y+x;
    encoder=reshape(m,[1 n_x*n_y]);
    for a=1:length(vec)
        z(a)=encoder(vec(a));
    end
end

