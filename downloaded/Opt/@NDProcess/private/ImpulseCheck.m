function [rc,newparam] = ImpulseCheck(param, sz);
% NDPROCESS/private/IMPULSECHECK
% param is parameter structure from constructor
%
% rc is return message.
% [] for valid parameters.
% also returns newparam, to allow for additional parameters.

rc = [];
newparam = param;
