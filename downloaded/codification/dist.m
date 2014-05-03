function y = dist(w,p)

% Computes the euclidic distance
% Used by viterbi.m

[s,r] = size(w);
[r2,q] = size(p);

if (r ~= r2), error('Matrix sizes do not match.'),end

y = zeros(s,q);

if r == 1
  for i=1:s
    x = w(i,:)'*ones(1,q);
    y(i,:) = abs(x-p);
  end
else
  for i=1:s
    x = w(i,:)'*ones(1,q);
    y(i,:) = sum((x-p).^ 2) .^ 0.5;
  end
end
