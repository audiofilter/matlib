%% gf_tb Testbench for Galois field arithmetics.
%%
%%   This testbench script runs without arguments and checks if the
%%   subsystem of Galois field arithmetics works.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Galois Field Arithmetics Testbench
%% Project       : MOUSE
%%
%% File          : gf_tb.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.7 $
%%---------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set system to defined state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization routines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_open;
gf_init (2, 8, [8 4 3 2 0]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import globals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global GF;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters and abbreviations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = GF.p;
m = GF.m;
q = GF.q;
alpha = GF.alpha;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('reading data.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = my_fopen ([getenv('MOUSE_TOP') '/app/dvbt/ref/gf_exp.ref'], 'r');
[expected_gf_exp, expected_length] = fread (f, Inf, 'uchar');
fclose (f);
if expected_length ~= q-1
  error ('corrupted reference file.');
end
f = my_fopen ([getenv('MOUSE_TOP') '/app/dvbt/ref/gf_log.ref'], 'r');
[expected_gf_log, expected_length] = fread (f, Inf, 'uchar');
fclose (f);
if expected_length ~= q-1
  error ('corrupted reference file.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking against stored tables:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf (' (log)');
if GF.log ~= expected_gf_log
  fprintf (' error\n');
  dump_close;
  error ('incorrect log table');
end
fprintf (' (exp)');
if GF.exp ~= expected_gf_exp
  fprintf (' error\n');
  dump_close;
  error ('incorrect exp table');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking table completeness:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf (' (log)');
if sort (GF.log)' ~= 1:q-1
  fprintf (' error\n');
  dump_close;
  error ('incorrect log table');
end
fprintf (' (exp)');
if sort (GF.exp)' ~= 1:q-1
  fprintf (' error\n');
  dump_close;
  error ('incorrect exp table');
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking table consistency:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:q-1
  if k ~= GF.log(GF.exp(k))
    fprintf (' error: k=%d, exp(%d)=%d, log(%d)=%d\n',...
             k, k, GF.exp(k), GF.exp(k), GF.log(GF.exp(k)));
    dump_close;
    error ('inconsistent log and exp tables');
  end
  if k ~= GF.exp(GF.log(k))
    fprintf (' error: k=%d, exp(%d)=%d, log(%d)=%d\n',...
             k, k, GF.log(k), GF.log(k), GF.exp(GF.log(k)));
    dump_close;
    error ('inconsistent log and exp tables');
  end
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking inversion property of addition:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = GF.all  
  if gf_add (k, k) ~= GF.zero
    fprintf (' error: k=%d, gf_add(%d, %d)=%d\n',...
             k, k, k, gf_add (k,k));
    dump_close;
    error ('error with inversion property');
  end
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking cyclic property of multiplication:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = GF.alpha;
for k = 2:q-1
  x = gf_mul (x, GF.alpha);
  if x == GF.zero | x == GF.alpha ...
        | (x == GF.one & k ~= q-1) | (x ~= GF.one & k == q-1)
    fprintf (' error: k=%d, alpha^k=%d^%d=%d\n',...
             k, GF.alpha, k, x);
    dump_close;
    error ('error with multiplication property');
  end
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking distributive law');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some random numbers
count = 2048;
data = floor(rand(count,3)*255.99);
for k = 1:count
  if rem (k,100) == 0
    fprintf ('.');
  end
  
  a = data(k,1);
  b = data(k,2);
  c = data(k,2);

  d1 = gf_mul (c, gf_add (a, b));
  d2 = gf_add (gf_mul (c, a), gf_mul (c, b));

  if d1 ~= d2
    fprintf (' error: a=%d, b=%d, c=%d, c(a+b)=%d, ca+cb=%d\n',...
             a, b, c, d1, d2);
    dump_close;
    error ('error with distributive property');
  end
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking logarithm and exponential:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf (' (log)');
for k = GF.all
  k_log = gf_log(k);
  if gf_exp (k_log) ~= k
    fprintf (' error: k=%d, gf_log(k)=%d, gf_exp(gf_log (k))=%d\n',...
             k, k_log, gf_exp (k_log));
    dump_close;
    error ('error with logarithm');
  end
end
if gf_log(GF.zero) ~= -Inf
  fprintf (' error: k=%d, gf_log(k)=%d\n',...
           GF.zero, gf_log(GF.zero));
  dump_close;
  error ('error with logarithm');
end
fprintf (' (exp)');
if gf_exp(-Inf) ~= GF.zero
  fprintf (' error: k=-Inf, gf_exp(k)=%d\n',...
           gf_exp(-Inf));
  dump_close;
  error ('error with exponential');
end
for k = 0:q-2
  k_exp = gf_exp(k);
  if gf_log (k_exp) ~= k
    fprintf (' error: k=%d, gf_exp(k)=%d, gf_log(gf_exp (k))=%d\n',...
             k, k_exp, gf_log (k_exp));
    dump_close;
    error ('error with exponential');
  end
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('checking inversion');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:q-1
  k_inv = gf_inv(k);
  if gf_mul (k, k_inv) ~= GF.one
    fprintf (' error: k=%d, gf_inv(k)=%d, gf_mul(k, gf_inv (k))=%d\n',...
             k, k_inv, gf_mul (k, k_inv));
    dump_close;
    error ('error with inversion');
  end
end
fprintf (' OK.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dump_close;
fprintf ('\n');
fprintf ('Galois field arithmetic works.\n');
