function [ntf,stf] = calculateTF(ABCD,k)
% [ntf,stf] = calculateTF(ABCD,k=1) 
% Calculate the NTF and STF of a delta-sigma modulator whose loop filter
% is described by the ABCD matrix, assuming a quantizer gain of k.
% The NTF and STF are TF structs of form 'zp' (zero/pole).
if nargin < 2 | isnan(k)
    k = 1;
end

[A,B,C,D] = partitionABCD(ABCD,2);
% Find the noise transfer function by forming the closed-loop
% system (CL) in state-space form.
Acl = A + k*B(:,2)*C;
Bcl = [B(:,1) + k*B(:,2)*D(1), B(:,2)];
Ccl = k*C;
Dcl = [k*D(1) 1];

[Hz,Hp,Hk] = ss2zp(Acl,Bcl,Ccl,Dcl,2);
if size(Hz,1) ~= size(Hp,1)
    fprintf(2,'%s error about to occur! Entering keyboard mode.\n', mfilename);
    keyboard
end
ntf.form = 'zp';
ntf.k = 1;
ntf.zeros = Hz';
ntf.poles = Hp';

if nargout > 1
    [Gz,Gp,Gk]=ss2zp(Acl,Bcl,Ccl,Dcl,1);
    Gz = padb(Gz,length(Gz),Inf);
    stf.form = 'zp';
    stf.k = Gk;
    stf.zeros = Gz';
    stf.poles = Gp';
end
