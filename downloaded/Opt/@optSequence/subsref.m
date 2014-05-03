function subs=subsref(seq,s)
%OPTSEQUENCE/SUBSREF subscript operator
%returns subsequence and elements of a sequence
%
% usage:  subs=subsseq(n) returns an optimized scalar
%         subs=subsseq(n1,n2) returns a subsequence

global OPT_DATA;

subs=[];
switch s.type
case '()'
    if length(s.subs)==2
        subs=optSequence;
        n1=max(s.subs{1}-seq.noff,1);
        n2=min(s.subs{2}-seq.noff,length(seq));
        subs.noff=seq.noff+n1-1;
        if OPT_DATA.casebug
            subs.optvector=seq.optvector(n1:n2);  % call optVector subsref
        else
            subs.optVector=seq.optVector(n1:n2);  % call optVector subsref
        end;
    elseif length(s.subs)==1
        if OPT_DATA.casebug
            subs=seq.optvector(s.subs{1}-seq.noff);  % call optVector subsref
        else
            subs=seq.optVector(s.subs{1}-seq.noff);  % call optVector subsref
        end
    else
        error('illegal arguments to subsref()')
    end;
otherwise
    error('illegal arguments to subsref()');
end;
