%% gf_init Initialize Galois Arithmetics.
%%
%%   gf_init() initializes a global data structure GF that define
%%   the Galois field which the other gf_* functions work with.
%%   Important parameters are the prime p, the extension parameter m,
%%   and the field generator polynome.
%%   This function is called by global_settings.

%%---------------------------------------------------------------------------
%%
%%     (C) COPYRIGHT 2003 VODAFONE Chair Mobile Communications Systems,
%%                    Technische Universität Dresden
%%                          ALL RIGHTS RESERVED
%%
%%---------------------------------------------------------------------------
%% Title         : Galois Fields - Initialization
%% Project       : MOUSE
%%
%% File          : gf_init.m
%% Author        : Gordon Cichon <cichon@radionetworkprocessor.com>
%%
%% Created       : 2003/04/23
%% Last checkin  : $Date: 2003/04/29 10:01:27 $ by $Author: mouse-gc $
%% Revision      : $Revision: 1.4 $
%%---------------------------------------------------------------------------

function gf_init (p, m, field_generator)

  global GF;

  % properties of Galois field
  % see Wicker, Bhargava. Reed-Solomon Codes. IEEE Press (ISBN 0-7803-1025-X)
  GF = {};
  
  % prime integer, use 2 for XOR arithmetic
  GF.p = p;
  assert (p == 2, 'gf', 'only XOR arithmetic supported');  
    
  % width of each code symbol in bits, usually 8 for a byte
  GF.m = m;
  assert (m == 8, 'gf', 'only byte sized code symbols supported');

  %                                                m
  % Number of elements of Galois field GF(q) = GF(p )
  GF.q = GF.p ^ GF.m;

  % all elements
  GF.all = 0:GF.q-1;
  GF.nz = 1:GF.q-1;
  
  % expand field generator polynomial representation
  GF.fgen = zeros(m+1,1);
  for k = 1:length(field_generator)
    GF.fgen(1+field_generator(k)) = 1;
  end
  GF.zero = 0;
  GF.one = 1;
  GF.alpha = p;

  % logarithm and exponential table for multiplication and division
  GF.log = zeros(GF.q-1,1);
  GF.exp = zeros(GF.q-1,1);
  
  x = zeros (GF.m+1,1);
  x(1) = 1;
  for k = 1:GF.q-1
    index = 0;
    for pos = 0:m-1
      index = index + x(1+pos) * GF.p^(pos);
    end
    assert (x(GF.m+1) == 0, 'gf', 'incorrect field generator');
    assert (0 < index & index < GF.q, 'gf', 'incorrect index');

    GF.exp(k) = index;
    GF.log(index) = k;

    x = [ 0 ; x(1:GF.m) ];
    if x(GF.m+1) == 1
      x = xor (x, GF.fgen);
    end
  end
