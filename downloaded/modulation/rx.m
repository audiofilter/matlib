function [out] = rx( in, type_flag, arg3, arg4, arg5 )

% RX ..........	Receiver function implementation using matched filter.
%
%	RX( Y, TYPE ) filters the sequence Y using a matched filter structure 
%		based on the parameter of TYPE.  The output of the filter is 
%		then sampled and compared to a threshold (set by the program).  
%
%		Allowed choices for the TYPE parameter are:
%		-------------------------------------------	
%		BASEBAND: 'polar_nrz' 'polar_rz' 'bipolar_rz' 'bipolar_nrz'
%			  'triangle' 'manchester' 'unipolar_nrz' 'unipolar_rz'
%		BAND-PASS: 'ask'  'psk'
%
%	RX( Y, TYPE, Ti, FLAG_DIFF, B_ORIGINAL ) with the last three being
%		optional parameters that can be specified in any order and 
%		combination.
%
%		Ti ........... : initial sampling instant for detection.
%				 Thus filter output will be sampled at 
%				 Ti, (Ti+Tb), (Ti+2Tb), ... (default: Ti = Tb).
%		FLAG ......... : 'diff' or 'no_diff' specifies differential 
%		      		 encoding (default: 'no_diff').
%		B_ORIGINAL ... : original binary sequence for BER computation
%		      		 (default: BER will not computed).
%
%	IF THE "Ti" PARAMETER IS NEGATIVE, THEN THE EYE DIAGRAM AT THE FILTER
%	OUTPUT WILL BE DISPLAYED AND YOU CAN INTERACTIVELY SPECIFY "Ti" AND 
%	"Threshold" PARAMETERS FOR THE DETECTOR. 

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
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global CARRIER_FREQUENCY;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Default values for flags and other parameters
%------------------------------------------------------------------------------

Ti_default    = 1/BINARY_DATA_RATE;
Ti            = 1/BINARY_DATA_RATE;
flag_diff     = 'no_diff';
original_flag = 0;

%------------------------------------------------------------------------------
%	Check input parameter consistency
%------------------------------------------------------------------------------

if ( (nargin ~= 2) & (nargin ~= 3) & (nargin ~= 4) & (nargin ~= 5) )
   error(eval('eval(BELL),eval(WARNING),help rx'));
   return;
end

%------------------------------------------------------------------------------
%	Check input parameters and assign function parameters.
%	Now this part is lengthy since we do not require a specific order for
%	"Ti", "Flag_diff" and "B_original" parameters.  Since they are all
%	different (Ti = scalar, Flag_diff = string and B_original = sequence)
%	we can check all combinations to make the life easier for the user.
%------------------------------------------------------------------------------

if (nargin == 3)

   if (isstr(arg3))
      flag_diff = arg3;
   elseif (length(arg3) == 1)
      Ti_default = arg3;
   else
      in_binary = arg3;
      original_flag = 1;
   end

elseif (nargin == 4)

   if (isstr(arg3))
      flag_diff = arg3;
   elseif (length(arg3) == 1)
      Ti_default = arg3;
   else
      in_binary = arg3;
      original_flag = 1;
   end
   if (isstr(arg4))
      flag_diff = arg4;
   elseif (length(arg4) == 1)
      Ti_default = arg4;
   else
      in_binary = arg4;
      original_flag = 1;
   end

elseif (nargin == 5)

   if (isstr(arg3))
      flag_diff = arg3;
   elseif (length(arg3) == 1)
      Ti_default = arg3;
   else
      in_binary = arg3;
      original_flag = 1;
   end
   if (isstr(arg4))
      flag_diff = arg4;
   elseif (length(arg4) == 1)
      Ti_default = arg4;
   else
      in_binary = arg4;
      original_flag = 1;
   end
   if (isstr(arg5))
      flag_diff = arg5;
   elseif (length(arg5) == 1)
      Ti_default = arg5;
   else
      in_binary = arg5;
      original_flag = 1;
   end

end

%------------------------------------------------------------------------------
%	Now the parameters are set let us decide about the cases and decide
%	about the default detector threshold "v_th"
%------------------------------------------------------------------------------

if( strcmp(type_flag, 'unipolar_nrz') )

    v_th = (1/2)/BINARY_DATA_RATE;
    linecode = type_flag;

elseif ( strcmp(type_flag, 'unipolar_rz') )

    v_th = (1/4)/BINARY_DATA_RATE;
    linecode = type_flag;

elseif ( strcmp(type_flag, 'bipolar_nrz')  )

    v_th = [(-1/2)  (1/2)]/BINARY_DATA_RATE;
    linecode = type_flag;

elseif ( strcmp(type_flag, 'bipolar_rz') ) 

    v_th = [(-1/4)  (1/4)]/BINARY_DATA_RATE;
    linecode = type_flag;

elseif ( strcmp(type_flag, 'polar_nrz') | strcmp(type_flag, 'polar_rz')  | ...
    strcmp(type_flag, 'triangle')  | strcmp(type_flag, 'manchester')  )

    v_th = 0;
    linecode = type_flag;

elseif ( strcmp(type_flag, 'ask') )

    v_th = (1/4)/BINARY_DATA_RATE;
    linecode = 'unipolar_nrz';
    in = mixer( in,osc( CARRIER_FREQUENCY(1) ) );

elseif ( strcmp(type_flag, 'psk') )

    v_th = 0;
    linecode = 'polar_nrz';
    in = mixer( in,osc( CARRIER_FREQUENCY(1) ) );

else

    error('Unknown or unsupported (linecode/modulation) type')

end

%------------------------------------------------------------------------------
%	Reciver filter
%------------------------------------------------------------------------------

out_match = match(linecode,in);

%------------------------------------------------------------------------------
%	Do we display the EYE_DIAGRAM or not?
%------------------------------------------------------------------------------

if( Ti_default < 0 )

   %--------------------------------------------------------
   %	Prepare messages
   %--------------------------------------------------------
   str_time = ...
       ['Enter initial sampling instant (',sprintf('%10.6f',Ti  ),' sec ) ...... = '];
   if ( strcmp(type_flag, 'bipolar_nrz')  | strcmp(type_flag, 'bipolar_rz') ) 
        str_vth  = ['Enter detector threshold ([',sprintf('%10.6f',v_th(1)),','...
             sprintf('%10.6f',v_th(2)),'] V ) ... = '];
   else
        str_vth  = ...
        ['Enter detector threshold  .... (',sprintf('%10.6f',v_th),' volts ) .... = '];
   end

   %--------------------------------------------------------
   %	Display the eye diagram
   %--------------------------------------------------------
   eye_diag(out_match);

   disp('');
   disp('Default values for the initial sampling instant and detector threshold ');
   disp('are shown in paranthesis.  If you accept these values hit the RETURN key.');
   disp('');

   f = input( str_time );
   if (~isempty(f)) 
      Ti = f; 
   end
   g = input( str_vth );
   if (~isempty(g)) 
      v_th= g;
   end
   disp('');

else
 
   Ti = Ti_default;

end 

x_binary = detect( out_match, v_th, Ti );

%------------------------------------------------------------------------------
%	 Check differential decoding
%------------------------------------------------------------------------------

if (strcmp(flag_diff,'no_diff'))
   out_binary = x_binary;
elseif (strcmp(flag_diff,'diff'))
   fprintf('o PERFORMING DIFFERENTIAL DECODING:\n');
   out_binary = diff_dec(x_binary);
   fprintf('\t Differential decoding complete;\n');
else
   error('Unknown request for differential encoding section');
end

if (original_flag)
    no_decision = min(length(in_binary),length(out_binary));
    seq0 =  in_binary(1:no_decision);
    seq1 = out_binary(1:no_decision);
    correct    = ~xor(seq0(:),seq1(:));
    no_correct = sum(correct);
    fprintf('Probability of bit error (BER) = %10.6f.\n',(1-no_correct/no_decision));
end

if (nargout == 1)
    out = out_binary;
end
