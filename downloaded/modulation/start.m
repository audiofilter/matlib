echo off;

%
% START ...............	Initialization of global variables used by the
%			Communication System Toolbox routines.

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
%	o   Added "checking" by START_OK 11.30.1992 MZ
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%       o       Modified under OCTAVE 2.0.14 2000.08.12 
%===========================================================================

START_OK = 2;     % MODIF. OCTAVE
global START_OK;
gset nokey;       % MODIF. OCTAVE

disp(' ');
disp('********************************************************************');
disp('*                                                                  *');
disp('*             COMMUNICATIONS SYSTEMS II  ---  ELE 045              *');
disp('*                                                                  *');
disp('*                      SIMULATION  LABORATORY                      *');
disp('*                     Version 2.0,  August 1991-1993               *');
disp('*                                                                  *');
disp('*                     M. ZEYTINOGLU  and  B. MA                    *');
disp('*         Department of Electrical & Computer Engineering          *');
disp('*                  Ryerson Polytechnic University                  *');
disp('*                     Toronto, Ontario, CANADA                     *');
disp('*                                                                  *');
disp('********************************************************************');
disp(' ');
disp('Welcome to simulation laboratory.  Before you start with any experiment');
disp('a number of global variables must be initialized.  Global variables are');
disp('set independently for each experiment.');
disp(' ');

table_index = input('Enter experiment number = ');

disp(' ');
disp(' ');

if( isempty(table_index) )
   error('Experiment number must be between 1 and 8.');
elseif( (table_index <= 0) | (table_index > 8) )
   error('Experiment number must be between 1 and 8.');
end

table = [ 10 100 10 10 8 100 40 8 ];

SAMPLING_CONSTANT  = table(table_index);
BINARY_DATA_RATE   = 1000;
SAMPLING_FREQ      = BINARY_DATA_RATE * SAMPLING_CONSTANT;

CARRIER_FREQUENCY  = [ 1000000 4000000 ];

NYQUIST_BLOCK   = 8;		% Number of blocks for Nyquist pulse generation
NYQUIST_ALPHA   = 0.5;		% Default value of "Excessive BW factor"
DUOBINARY_BLOCK = 8;		% Number of blocks for Duobinary pulse.

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global CARRIER_FREQUENCY;
global NYQUIST_BLOCK;
global NYQUIST_ALPHA;
global DUOBINARY_BLOCK;

fprintf('====================================================================');
fprintf('\n\n');
fprintf('   In this OCTAVE session default sampling frequency is set at \n\n');
fprintf('\t\t %6.2f [kHz].\n\n',SAMPLING_FREQ/1000);
fprintf('   Highest frequency component that can be processed by all \n');
fprintf('   OCTAVE routines is less than or equal to: \n\n');
fprintf('\t\t %6.2f [kHz].\n',SAMPLING_FREQ/2000); 
fprintf('\n');
fprintf('====================================================================');
fprintf('\n\n');
disp('These values will remain in effect until the "SAMPLING_FREQ" or the');
disp('"BINARY_DATA_RATE" variables are changed.  If you specify Rb as the');
disp('new binary data rate, then the sampling frquency will be set to:');
fprintf('\n\t\t(%4.0f)Rb [Hz].\n',SAMPLING_CONSTANT);
fprintf('\n');

%
% The next two variables are for error messages only
%

BELL    = 'fprintf(''\a\a\a'')'; % MODIF. OCTAVE
WARNING = 'fprintf(''\\n\t * NOT SUFFICIENT INPUT ARGUMENTS \t * USAGE:\\n\\n'')';
% BELL    = 'fprintf(''\007\007\007'')';
% WARNING = 'fprintf(''\n\t * NOT SUFFICIENT INPUT ARGUMENTS \t * USAGE:\n'')';

global BELL;
global WARNING;

clear table table_index;
