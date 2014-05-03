function h = evalTF(tf,z)
%h = evalTF(tf,z)
%Evaluates the rational function described by the struct tf
% at the point(s)given in the z vector.
% The TF struct contains:
%   form		'zp' or 'coeff'
%   zeros,poles,k	if form=='zp'
%   num,den		if form=='coeff'
if strcmp(tf.form,'zp')
    h = tf.k * evalRPoly(tf.zeros,z) ./ evalRPoly(tf.poles,z);
elseif strcmp(form,'coeff')
    h = polyval(tf.num,z) ./ polyval(tf.den,z);
else
    fprintf(1,'%s: Unknown form: %s\n', mfilename ,tf.form);
end
