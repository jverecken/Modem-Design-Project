function [u,yDecoded,M] = viterbi(y,lambda)
% y         size [Nx2] normalized
% lambda    size [Nx1]
% u         size [Nx1]

%% parameters
N = length(y(:,1));

% nextstate connections
transitions = [0 0;
    0 1;
    1 2;
    1 3;
    2 0;
    2 1;
    3 2;
    3 3]+1;

% G(D) = [1+D ; 1+D+D^2]
treillis = [0;
    3;
    3;
    0;
    1;
    2;
    2;
    1];

%% init
% prealloc distance, path array
distance = 1e6*ones(4,N+1);
path = zeros(4,N);

% first column is zero distance
distance(:,1) = zeros(4,1);

% binary representation for soft decoding (-1/sqrt(2) and 1/sqrt(2))
treillisbin = zeros(8,2);
for i = 1:8
    treillisbin(i,:) = num2bin(treillis(i),2);
end

%% compute full size treillis
% for cell
for k = 1:N
    % for node
    for j = 1:4
        % for arrow
        for i = 0:1
            arrow = (2*j-1)+i;
            % compute ML metric
            diff = (y(k,:) - lambda(k)*treillisbin(arrow,:));
            d = distance(j,k) + (diff * diff');
            
            % if small metric, save distance and path
            % save it on in the position the arrow points
            if d < distance(transitions(arrow,2),k+1)
                distance(transitions(arrow,2),k+1) = d;
                % path saves arrow
                path(transitions(arrow,2),k) = arrow;
            end
        end
    end
end

%% decode
% prealloc
yDecoded = zeros(N,2);
u = zeros(N,1);
next = zeros(N+1,1);

% go backward in the path
[M,next(N+1)] = min(distance(:,N+1));
for k=1:N
    arrow = path(next(N+2-k),N+1-k);
    next(N+1-k) = transitions(arrow,1);
    yDecoded(N+1-k,:) = treillisbin(arrow,:);
    u(N+1-k) = mod(arrow,2) == 0;
end

%% draw the nice treillis

figure;
drawTreillis(transitions,treillis,N);
plot(0:N,4-next,'-','color',[0,1,1,0.5],'linewidth',3.5,'displayname','Decoded');

end

function drawTreillis(transitions,treillis,N)
colors = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.4940 0.1840 0.5560;
    0.4660 0.6740 0.1880];
for i=1:N
    for j=1:4
        plot([i-1 i],4-transitions(2*j-1,:),'-','Color',colors(j,:),'linewidth',1.5); hold on;
        plot([i-1 i],4-transitions(2*j,:),'--','Color',colors(j,:),'linewidth',1.5);
        if i == 1
            label{2*j-1} = sprintf('%d',treillis(2*j-1));
            label{2*j} = sprintf('%d',treillis(2*j));
        end
    end
    plot(repmat(i-1,4,1),0:3,'.k','markersize',15);
    plot(repmat(i,4,1),0:3,'.k','markersize',15);
end
axis equal;
axis off;
legend(label);
end

function b = num2bin(x,N)
b = zeros(1,N);
for i = 0:N-1
    if x == 0
        break;
    elseif x >= 2^(N-1-i)
        x = x - 2^(N-1-i);
        b(i+1) = 1;
    end
end
b = (b*2-1)/sqrt(2);
end