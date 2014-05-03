function [mtx, xoff, yoff] = i2m(tau, coeff)
% SP2FU 
%   converts "indexed" filter to matrix form.

dim = size(tau,2);
if dim>2
    error('i2m works only for 1-D or 2-D filters.')
end
if any(tau-floor(tau))
    error('non-integer entries in locations matrix')
end
if ~isreal(tau)
    error('non-real entries in locations matrix');
end;

coeff = coeff(:);
if size(tau,1) ~= size(coeff,1)
    error('set of locations must have same length as coefficient vector');
end;
[tau,sid] = sortrows(tau(find(coeff),:));
coeff = coeff(find(coeff));      % only take nonzero entries
coeff = coeff(sid);
if ~isempty(find(sum(abs(diff(tau,1,1)) , 2)<10*eps))
    % since tau is sorted check for neighboring matches
    error('duplicate entries in locations matrix');
end;

if dim == 2
    minX = min(tau(:,1)); maxX = max(tau(:,1));
    minY = min(tau(:,2)); maxY = max(tau(:,2));
    xoff = minX - 1; yoff = minY - 1;
    M = maxX - minX + 1;
    N = maxY - minY + 1;
    mtx = zeros(N, M); % counterintuitive orientation of mtx
    for qq = 1:size(tau,1)
        ii = tau(qq,1) - xoff;
        jj = tau(qq,2) - yoff;
        mtx(jj, ii) = coeff(qq); % stupid MATLAB tricks, mtx must
                                 % be transposed by using (jj,ii)
    end        
else
    error('not yet for 1-D')
end


