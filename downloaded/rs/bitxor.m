function result = bitxor (arg1, arg2)
% bitxor bitwise xor of to numbers
% works much like bitxor in the Matlab library.

  [errorcode, byte_vector1, byte_vector2] = common_size (arg1, arg2);
  assert (errorcode == 0, ...
	  'bitxor', 'vector dimensions do not match');

  [m, n] = size (byte_vector1);

  result = zeros (m, n);

  for i = 1:m
    for j = 1:n
      byte1=byte_vector1(i,j);
      byte2=byte_vector2(i,j);
      result_byte=0;
      for k = 1:8
	bit1=rem(byte1,2);
	bit2=rem(byte2,2);
	result_bit=xor(bit1,bit2);
	result_byte=result_byte + result_bit*2^(k-1);
	byte1=fix(byte1/2);
	byte2=fix(byte2/2);
      end
      result(i,j)=result_byte;
    end
  end

