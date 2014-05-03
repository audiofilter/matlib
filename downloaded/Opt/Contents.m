%      Opt - An FIR filter optimization toolbox
%
% Routines:
%    InitOpt     - Set up workspace.  Must be callsed first.
%    newOptSpace - Allocate a new pool of optimization variables
%    minimize    - Perform an optimization
%
% Classes (user visible):
%    optVector   - Vector that depends linearly on the optimization variables
%    optSequence - an optVector with time information
%    optGenSequence - an optSequence with noninteger spacing allowed
%    optArray    - multi-dimensional optGenSequence
%    Process     - a zero-mean, wide-sense stationary random process
%    CTProcess   - a zero-mean, WSS continuous-time random process
%    NDProcess   - a zero-mean, WSS multi-dimensional random process
%    Lattice     - Lattice of points
%    Region      - Describes region in space
