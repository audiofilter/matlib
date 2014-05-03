function plot1(soln);
global x y d px py m b;

x1=-2:0.01:4;
y1=2-2*x1;
plot(x1,0,'k'); hold on; plot(0,x1,'k');
plot(x1,y1); axis([-2 4 -2 4]);
plot(px,py,'gx');
plot([px-4 px],[py+4/m py],'c:');
plot(double(optimal(x,soln)),double(optimal(y,soln)),'rx');
hold off; pbaspect([1 1 1]);
d1=sqrt((double(optimal(x,soln))-px)^2+(double(optimal(y,soln))-py)^2);
text(2,2,['d = ' num2str(d1)]);
drawnow; pause(1);
