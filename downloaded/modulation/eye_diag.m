function eye_diag(x,kk)

% EYE_DIAG ....	Eye diagram generation and display.
%
%	EYE_DIAG(X) displays the eye diagram of the input sequence X.
%	EYE_DIAG(X,K) displays the eye diagram of the input sequence X, 
%		but waits K seconds between succesive display updates.
%		If K is negative, the user must hit the RETURN key for 
%		successive display updates.

%	AUTHORS : M. Zeytinoglu & N. W. Ma
%             Department of Electrical & Computer Engineering
%             Ryerson Polytechnic University
%             Toronto, Ontario, CANADA
%
%	DATE    : August 1991.
%	VERSION : 1.0

%===========================================================================
% Modifications history:
% ----------------------
%	o   Added "checking"  11.30.1992 MZ
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%       o       Modified under OCTAVE 2.0.14 2000.08.12 
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Set up parameters
%------------------------------------------------------------------------------

if ((nargin ~= 1) & (nargin ~= 2))
   error(eval('eval(BELL),eval(WARNING),help eye_diag'));
   return;
elseif (nargin == 1)
   kk = 0;
end

Rb = BINARY_DATA_RATE;
Tb = 1/Rb;
Ts = 1/SAMPLING_FREQ;
gset nokey;
clearplot;

%------------------------------------------------------------------------------
%	Input consistency control
%------------------------------------------------------------------------------

no_eye     = 2;					% No. of eye diagrams
no_sample  = Tb/Ts;				% No. of samples per period
tot_sample = length(x);				% Total no. of samples
no_block   = fix(tot_sample/(no_eye*no_sample));% No. of blocks of no_samples
if(no_block > 150) no_block = 150; end
if(no_block < 2)
   error('not enough input data');
end

index      = [1:(no_eye*no_sample)];		% index for selecting input
t_time     = Ts * [0:no_eye*no_sample];		% time for displaying EYE
time       = Ts * [1:no_eye*no_sample];
amplitude  = max(abs(x));

max1=max(x); min1=min(x);    % MODIF.
delta=0.1*abs(max1-min1);
if(delta==0) delta=1; end
amplitude2=max1+delta;
amplitude1=min1-delta;

%------------------------------------------------------------------------------
%   To test whether the signal is digital or analog waveform.
%
%------------------------------------------------------------------------------

foo = x;
foo(x ==  amplitude) = zeros(length(x(x == amplitude)),1);
foo(x == -amplitude) = zeros(length(x(x == -amplitude)),1);
flag = mean(abs(foo));

% IF THE SIGNAL IS PAM
if(rem(length(x),SAMPLING_CONSTANT)==0)
     foo=(reshape(x,SAMPLING_CONSTANT,length(x)/SAMPLING_CONSTANT)); % MODIF.
     if(max(foo)==min(foo)) flag=0; end
end

%------------------------------------------------------------------------------
%   If the signal is digital, use 'stair' function to plot
%   the eye diagram. Otherwise, 'plot' is used.
%------------------------------------------------------------------------------

if(flag == 0)
   axis;
   hold on;
   [xx,yy]=stair(time,x(index));  
   foo = zeros(length(yy), no_block);
   foo(:,1) = yy;
   for k = 2:(no_block)
       index = index + (no_eye*no_sample);
       [xx,foo(:,k)]=stair(time,x(index));
   end

   if (nargin == 1)
%       axis([0, max(t_time), -1.25*amplitude, 1.25*amplitude]); ...
       axis([0, max(t_time), amplitude1, amplitude2]); ...
       xlabel('Time [sec]'),                                    ...
       grid,                                                    ...
       title('EYE DIAGRAM'),                                    ...
       plot(xx,foo); ... % plot(xx,foo,"1"); 
   else
%       axis([0, max(t_time), -1.25*amplitude, 1.25*amplitude]); ...
       axis([0, max(t_time), amplitude1, amplitude2]); ...
       xlabel('Time [sec]'),                                    ...
       grid,                                                    ...
       title('EYE DIAGRAM');                                    ...
       plot(xx,foo(:,1)); ...  % plot(xx,foo(:,1),"1"); ...
	   hold on;
       for k = 2:no_block
          if (kk < 0)
             pause; 
          else 
             pause(min(kk,5));
          end
	      plot(xx, foo(:,k));  % plot(xx, foo(:,k),"1");
	   end
   end

%   axis([0, max(t_time), -1.25*amplitude, 1.25*amplitude]); ...
   axis([0, max(t_time), amplitude1, amplitude2]); ...
   xlabel('Time [sec]'),                                    ...
   grid,                                                    ...
   title('EYE DIAGRAM');
   plot(xx,foo);   %   plot(xx,foo,"1"); ...

else

   slope = x(2) - x(1);        % estimate the first value
   first = x(1) - slope;       % of the input waveform
   if(((first < 0) & (x(1)>0)) | ((first>0) & (x(1)<0))) first = 0; end
   y = x(index);
   grid,                                          ...
   xlabel('Time [sec]'),                          ...
%   axis([0, max(t_time), -amplitude, amplitude]); ...
   axis([0, max(t_time), amplitude1, amplitude2]); ...
   title('EYE DIAGRAM'),                          ...
   % plot(t_time,[first y(:).'],"1"), ...
   if(size(y,2)==1) y=y'; end  % MODIF. OCTAVE
   plot(t_time,[first y]);     % MODIF. OCTAVE
   hold on
   maxindex = max(index);

   foo = zeros((no_eye*no_sample), no_block-1);
   % foo(:) = x( (no_eye*no_sample)+1 : no_block*no_eye*no_sample );
   foo= x( (no_eye*no_sample)+1 : no_block*no_eye*no_sample ); % MODIF. OCTAVE
   foo=reshape(foo,(no_eye*no_sample), no_block-1);            % MODIF. OCTAVE
   first_row = foo(no_eye*no_sample,:);
   first_row = [x(maxindex) first_row(1:no_block-2)];
   foo = [first_row;  foo];

   if (nargin == 1)
%       axis([0, max(t_time), -amplitude, amplitude]); ...
       axis([0, max(t_time), amplitude1, amplitude2]); ...
       plot(t_time, foo); %  plot(t_time, foo,"1");
   else
%       axis([0, max(t_time), -amplitude, amplitude]); ...
       axis([0, max(t_time), amplitude1, amplitude2]); ...
       for k = 1:(no_block-1)
          if (kk < 0)
             pause; 
          else 
             pause(min(kk,5));
          end
	      plot(t_time, foo(:,k)); % plot(t_time, foo(:,k),"1");
	   end
   end

end

hold off
axis;
