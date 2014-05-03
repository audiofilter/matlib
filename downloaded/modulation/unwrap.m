## Usage: b = unwrap(a{,tol{,dim}})
## 
## Unwrap radian phases by detecting jumps greater in magnitude
## than "tol" (default pi) and adding or subtracting 2*pi as
## appropriate.
##
## Unwrap will unwrap along the columns of "a" unless the row
## dimension of "a" is 1 or the "dim" argument is given with a
## value of 1, when it will unwrap along the row(s).

## Verification steps:
##
##      r = [0:100];                            #original vector
##      w = r - 2*pi*floor((r+pi)/(2*pi));      #wrapped version value between -pi and pi
##
##      max(abs(r-unwrap(w)))                   #unwrap single row
##      max(abs(r'-unwrap(w')))                 #unwrap single column
##      max(max(abs([r',r']-unwrap([w',w']))))  #unwrap 2 columns
##      max(max(abs([r;r]-unwrap([w;w],[],1)))) #unwrap 2 rows by specifying dimension
##      max(abs((r+10)-unwrap(10+w)))           #verify that first element greater than pi will
##                                              #not cause problems
##
##      max(abs(w'-unwrap(w',[],1)))            #unwrapping a col vector by rows should not change it
##      max(abs(w-unwrap(w,[],2)))              #unwrapping a row vector by cols should not change it
##      max(max(abs([w;w]-unwrap([w;w]))))      #unwrapping 2 rows by cols should not change
##
##      max(abs(r-unwrap(w,0.8)))               #verify that setting tolerance too low will cause
##                                              #different (bad) results.

## Bill Lash
## lash@tellabs.com

function retval = unwrap(a,tol,dim)
        
        if ((nargin<1) || (nargin>3))
                usage("unwrap(a,[tol,[dim]])")
        endif
        if (nargin < 3)
                if (rows(a)==1)
                        dim = 1;        #row vector, go along the row
                else
                        dim = 2;        # Otherwise go along the columns
                endif
        endif
        if (nargin < 2)
                tol = pi;
        endif
        if (tol == [])          # if tol is not provided but dim is, handle it
                tol = pi;
        endif
        tol = abs(tol);         # don't let anyone use a negative tol

        rng = 2*pi;

        #
        # Want to get data in a form so that we can unwrap each column
        #
        if (dim == 1)
                ra = a.';
        else
                ra = a;
        endif
        n = columns(ra);
        m = rows(ra);

        if (m == 1)             # Handle case where we are trying to unwrap 
                retval = a;     # a scalar, or only have one sample in the 
                return;         # specified dimension
        endif

        #
        # take first order difference to see so that wraps will show up
        # as large values, and the sign will show direction
        #
        d = [zeros(1,n);ra(1:m-1,:)-ra(2:m,:)];

        #
        # Find only the peaks, and multiply them by the range so that there
        # are kronecker deltas at each wrap point multiplied by the range
        # value
        #
        p =  rng * (((d > tol)>0) - ((d < -tol)>0));

        #
        # Now need to "integrate" this so that the deltas become steps
        #
        r = cumsum(p);

        #
        # Now add the "steps" to the original data and put output in the
        # same shape as originally
        #
        if (dim == 1)
                retval = (ra + r).';
        else
                retval = (ra + r);
        endif

endfunction

