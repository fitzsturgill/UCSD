%% Given code
n = 10;
x = rand(1,n);
y = rand(1,n);

%% Rob's solution
pairs = nchoosek(1:n,2);
dist = sqrt((diff(x(pairs),1,2)).^2 + (diff(y(pairs),1,2)).^2);
[B,IX] = sort(dist);
figure, scatter(x,y);
hold on;
plot([x(pairs(IX(1),:))],[y(pairs(IX(1),:))],'-+r');