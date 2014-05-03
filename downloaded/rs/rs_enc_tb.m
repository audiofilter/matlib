clear all;

global_settings;

global GF;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters and abbreviations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = 1;
k = RS.k;
n = RS.n;
t = RS.t;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('reading data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reed/Solomon Code Generator Polynome
f = my_fopen ([getenv('MOUSE_TOP') '/home/tkirke/opendvb/ref/rs_cgp.ref'], 'r');
[rs_cgp expected_length] = fread (f, Inf, 'uchar');
fclose (f);
if expected_length ~= 2*t+1
  error ('corrupted reference file.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking against stored tables:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf (' (cgp)');
if RS.g ~= rs_cgp
  fprintf (' error\n');
end
fprintf (' OK.\n');

