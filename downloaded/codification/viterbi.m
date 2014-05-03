function xx_hat = viterbi( g, rr )

% Usage: xx_hat = viterbi( g, rr )
%
% Soft decision Viterbi decoding algorithm.
%
% Takes an entire convolutionally encoded (and possibly corrupted)
% codeword with values between [-1 and 1] and returns an estimate
% of the information bits (not including tail bits).
%
% Original author: M.C. Valenti
% For academic use only


% A VITERBI FOR EACH ROW
for ii=1:size(rr,1)
r=rr(ii,:);


[n,K] = size(g);
m = K - 1;
max_state = 2^m;
[temp, rec_size] = size(r);
L_total = rec_size/n;
L_info = L_total - m;

% set infiinity to an arbitrarily large value
inf = 10^5;

% initialize trellis and path matrices
trellis = inf*ones(max_state,L_total);
path = zeros(max_state,L_total);
new_path = path;

% initialize output and transition matrices
for state=1:max_state
   state_vector = bin_state( state-1, m );
   if(size(state_vector,2)==1) state_vector=state_vector'; end
   [out_0, state_0] = bit_encode(g, 0, state_vector);
   [out_1, state_1] = bit_encode(g, 1, state_vector);
   output(state,:) = [out_0 out_1];
   transition(state,:) = [(int_state(state_0)+1) (int_state(state_1)+1)];
end

% determine trellis and path matrices at time 1
y_segment = r(1,1:n);
for i=0:1
   hypothesis = 2*output( 1, n*i+1:n*(i+1) )-1;
   next_state = transition(1,i+1);
   dist_euclidian = dist( hypothesis, y_segment' );
   path_metric = dist_euclidian^2;
   trellis(next_state,1) = path_metric;
   path(next_state,1) = i;
end

% now determine trellis and path matrices for times 2 through L
counter = n +1;
for time=2:L_total
   y_segment = r( 1,counter:counter+n-1);
   counter = counter + n;
   for state=1:max_state
      for i=0:1
         hypothesis = 2*output( state, n*i+1:n*(i+1) )-1;
         next_state = transition( state, i+1 );

         % compute squared Euclidian distance
         square_dist = 0;
         for j = 1:n
            % y_semgment(j) == 0 indicates an erasure
            if y_segment(j) 
               square_dist = square_dist + (hypothesis(j)-y_segment(j))^2;
            end
         end

         % update path metric
         path_metric = square_dist + trellis(state,time-1);
         if path_metric < trellis( next_state, time )
            trellis( next_state, time ) = path_metric;
            new_path( next_state, 1:time ) = [path(state,1:time-1) i];
         end
      end
   end
   path = new_path;
end

x_hat = path(1,1:L_info);

xx_hat(ii,:)=x_hat;
end
