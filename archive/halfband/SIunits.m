function [factor,prefix] = units(x)
prefixes_n = ['m';'u';'n';'p';'f';'a'];
prefixes_p = ['k';'M';'G';'T';'E';'P'];
p = floor(log10(x)/3);
if p>0 
    p = min(p,length(prefixes_p));
    prefix = prefixes_p(p);
    factor = 10^(3*p);
elseif p<0 
    p = min(-p,length(prefixes_n));
    prefix = prefixes_n(p);
    factor = 10^(-3*p);
else
    prefix = '';
    factor = 1;
end
