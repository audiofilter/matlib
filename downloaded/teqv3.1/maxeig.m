%MAXEIG Maximum eigenvalue and the corresponding eigenvector.
% [L, Q] = MAXEIG(A) returns the maximum eigenvalue L and the
% corresponding eigenvector Q of the square matrix A. Maximum is 
% in the sense of absolute value if complex eigenvalues exist.
%
% [L, Q] = MAXEIG(A, B) returns the maximum generalized eigenvalue
% L and the corresponding generalized eigenvector Q of the square
% matrix A. Maximum is in the sense of absolute value if complex 
% eigenvalues exist.

% Copyright (c) 1999-2003 The University of Texas
% All Rights Reserved.
%  
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%  
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%  
% The GNU Public License is available in the file LICENSE, or you
% can write to the Free Software Foundation, Inc., 59 Temple Place -
% Suite 330, Boston, MA 02111-1307, USA, or you can find it on the
% World Wide Web at http://www.fsf.org.
%  
% Programmers:	Guner Arslan
% Version:        @(#)maxeig.m	1.3	07/26/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [l, q]=maxeig(varargin);

if nargin==2 % if two matrixes are given
  % generalized EVD
  [v, d]=eig(varargin{1},varargin{2});		
elseif nargin==1 % if one matrix is given
  % normal EVD						
  [v, d]=eig(varargin{1},'nobalance');					
end

% find the maximum eigenvalue and the index to it
[l, ind]=max(real(diag(d)));				
% this is the corresponding eigenvector
q = real(v(:,ind));				
