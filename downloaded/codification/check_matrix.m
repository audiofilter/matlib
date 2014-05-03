function H = check_matrix(G)

% Usage: H = check_matrix(G)
%
% Given a generator matrix 'G', determines the parity
% check matrix 'H' in systematic form.
%
% Original author: M.C. Valenti
% For academic use only

% get dimensions of the G matrix
[k,n] = size(G);

% put G into systematic form
G_sys = syst_matrix(G);

% strip off the parity generation part
P = G_sys(:,k+1:n);

% H = [ eye(n-k) P'];
H = [P' eye(n-k) ];  % MODIF. OCTAVE

end
