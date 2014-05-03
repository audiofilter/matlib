function optq=optimal(quad,soln)
% OPTQUAD/OPTIMAL  return optimal quadratic (scalar)
% optq=optimal(quad,soln)

if isa(soln, 'Solution')
  soln = get_x(soln);
end

[M,N]=size(quad.kernel);
Q=sparse(1+length(soln),1+length(soln));
%ar=(1+quad.xoffr+1):(M+quad.xoffr+1);
%ac=(1+quad.xoffc+1):(N+quad.xoffc+1);
%Q(ar,ac)=quad.kernel;
ar = (1+quad.xoff+1):(M+quad.xoff+1);
Q(ar,ar) = quad.kernel;
optq=real([1;soln].'*Q*[1;soln]);
