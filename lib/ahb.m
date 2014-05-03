function y = ahb(x)

g1 = 0.75;
g2 = 0.25;

y1 = filter([0 g1 0 1],[1 0 g1],x);
y2 = filter([g2 0 1],[1 0 g2],x);

y = 0.5*(y1 + y2);
