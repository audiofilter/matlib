function y = group9(x,offset)
n = size(x,1) - 9;
i = offset;
j = 0;
while (i < n)

  for k=1:9
	j = j+1;
	i = i+1;
	y(j) = x(i);
  endfor
  i = i+9; # skip 9

endwhile
