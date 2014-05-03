function [f1_saved,f2_saved,q1_saved,q2_saved,info]=designHBF(fp,delta,debug)
%function [f1,f2,q1,q2,info]=designHBF(fp=0.2,delta=1e-5)
%Design a half-band filter which can be realized without general multipliers.
%The filter is a composition of a prototype and sub- filter.
%Input
% fp	The normalized cutoff frequency of the filter. Due to the
%	symmetry imposed by a HBF, the stopband begins at 0.5-fp.
% delta	The absolute value of the deviation of the frequency response from 
%	the ideal values of 1 in the passband and  0 in the stopband.
%
%Output
% f1,f2	The coefficients of the prototype and sub-filters.
% q1,q2	The coefficients of the prototype and sub-fitlers, decomposed 
%	into signed powers of two.
% info	A vector containing the following data (only set when debug=1):
%	complexity	The number of additions per output sample.
%	n1,n2		The length of the f1 and f2 vectors.
%	nsd1,nsd2	The number of signed digits in each of q1 and q2.
%	sbr		The achieved stob-band attenuation (dB).
%	phi		The scaling factor for the F2 filter.

%Handle the input arguments
parameters = ['fp   ';'delta';'debug'];
defaults = [ 0.2 1e-5 0];
for i=1:length(defaults)
    if i>nargin
       eval([parameters(i,:) '=defaults(i);'])
    elseif eval(['any(isnan(' parameters(i,:) ')) | isempty(' parameters(i,:) ')']) 
       eval([parameters(i,:) '=defaults(i);'])
    end
end

%Try several different values for the fp1 parameter.
%The best values are usually around .04
%Surrender if 3 successive attempts yield progressively greater complexity.
lowest_complexity = Inf;	prev_complexity = Inf;
for fp1 = [.03 .035 .025 .040 .020 .045 .015 .05]
    failed = 0;
    [f1 q1 zetap phi] = designF1( delta, fp1 );
    if zetap == 1	% designF1 failed
	failed = 1;
	if debug
	    fprintf(2,'designF1 failed at fp1=%f\n',fp1);
	end
    end
    if ~failed
%	[f2 q2] = designF2( fp, zetap, phi );
	f2 = [5/8 -1/8 0];
	q2 = 8*f2;
	[n1 nsd1] = size(q1); n1 = n1/2; [n2 nsd2] = size(q2); n2 = n2/2;
	if n2 == 0		% designF2 failed
	    failed = 1;
	    if debug
		fprintf(2,'designF2 failed when zetap=%f, phi=%f\n',zetap,phi);
	    end
	end
    end
    if ~failed
	% complexity(+ performance)  = the number of two-input adders (+ sbr)
	complexity =  n1*nsd1 + (2*n1-1)*((nsd2+1)*n2-1);
	if debug
	    msg = sprintf('%d adders: n1=%d, n2=%d, nsd1=%d, nsd2=%d, (fp1=%.2f, zetap=%.3f, phi=%4.2f)', ...
		complexity, n1, n2, nsd1, nsd2, fp1, zetap, phi );
	else
	    msg = '';
	end
	[fresp pbr sbr] = frespHBF(f1, f2, [], phi, fp, msg);
	if pbr <= delta & sbr <= delta          
	    complexity = complexity + sbr;
	    if complexity < prev_complexity
		worse = 0;
		if complexity < lowest_complexity 
		    lowest_complexity = complexity;
		    q1_saved = q1;	q2_saved = q2;
		    f1_saved = f1;	f2_saved = f2;
		    phi_saved = phi;
		    if debug
			fprintf( 1, '%s\n', msg )
		    end
		end
	    else
		worse = worse + 1;
		if worse > 2
		    break;
		end
	    end
	    prev_complexity = complexity;
	end	    % if pbr <= delta
    end	    
end	    % for fp1

if isinf(lowest_complexity)
    fprintf(1,'%s: Unable to meet the design requirements.\n', mfilename);
elseif debug 
    complexity = floor(lowest_complexity);
    msg = sprintf( 'Final Design: %d adders', complexity);
    [junk pbr sbr] = frespHBF(f1_saved, f2_saved, [], phi_saved, fp, msg);
    [n1 nsd1] = size(q1_saved); n1 = n1/2; [n2 nsd2] = size(q2_saved); n2 = n2/2;
    fprintf(1,'%s (%d,%d,%d,%d,%.0fdB)\n', msg,n1,n2,nsd1,nsd2,dbv(sbr));
    info = [ complexity n1 n2 nsd1 nsd2 dbv(sbr) phi_saved ];
end
