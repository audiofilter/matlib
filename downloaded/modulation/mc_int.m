function mc_int(f)

global MENU_x;
global MENU_min_x;
global MENU_max_x;
global MENU_n;

x     = MENU_x;
min_x = MENU_min_x;
max_x = MENU_max_x;
n     = MENU_n;

gx = eval(f);

min_y   = min(gx);
max_y   = max(gx);
ceiling = 10*max_y;

if ( (sign(min_y) == sign(max_y)) & (min_y > 0) )
   min_y = 0; 
   ceiling = 10*max_y;
end
if ( (sign(min_y) == sign(max_y)) & (max_y < 0) )
   max_y = 0; 
   ceiling = 10*min_y;
end

y = uniform(min_y,max_y,n);

%---------------------------------------------------------------------------
%	Set y-coordinates to "ceiling" if outside the area of integration
%---------------------------------------------------------------------------
index_pos = (gx >  0) & ( (y > gx) | (y <  0));
index_neg = (gx <= 0) & ( (y < gx) | (y >= 0));
index = index_pos + index_neg;
total = sum(index);
y(index) = ceiling * ones(total,1);

%---------------------------------------------------------------------------
%	This part is for estimating the area
%---------------------------------------------------------------------------
c = zeros(size(y));
c = ((y>0) & ~index) - ((y<=0) & ~index);
area = (sum(c)/n) * (max_y - min_y) * (max_x - min_x);
title_area = [ sprintf('AREA = %5.3f',area) ];

%---------------------------------------------------------------------------
%	Now plot the result and display the estimated AREA
%---------------------------------------------------------------------------
%axis('square'); 
axis( [ min_x max_x min_y max_y ] ); ...
grid,              ...
title( title_area ), ...
xlabel('x'); ylabel('y');
plot( x, y, '.');  ...
