function [q]=energy(opt);
% [q]=energy(opt)  energy (sum of squares)
% returns quadratic form representing energy
% or a scalar if opt doesn't depend on optimization variables

q=sum(abs(opt).^2);  % alias to optQuadVector functions
