#include <math.h>
#include "mex.h"

/* Input Arguments */

#define	X_IN	prhs[0]
#define	Y_IN	prhs[1]

/* Output Arguments */

#define	MAP_OUT	plhs[0]

#if !defined(MAX)
#define	MAX(A, B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define	MIN(A, B)	((A) < (B) ? (A) : (B))
#endif

#define PI 3.14159265


void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )     
{ 
  double *x; 
  double *y; 
  double *map;
  unsigned int mx, nx, my, ny;
  unsigned int qq, zz, kk;	    /* loop indexes */ 
  unsigned int flag;
  double NaNValue = mxGetNaN();
    
  /* Check for proper number of arguments */
    
  if (nrhs != 2) { 
    mexErrMsgTxt("Two input arguments required."); 
  } 
  else if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments."); 
  } 
    
  /* Get size of inputs */
  mx = mxGetM(X_IN); 
  nx = mxGetN(X_IN);
  my = mxGetM(Y_IN); 
  ny = mxGetN(Y_IN);

  /* Assign pointers to the various parameters */ 
  x = mxGetPr(X_IN); 
  y = mxGetPr(Y_IN);

  /* Create a matrix for the return argument */ 
  if (my == 0) {
    mxErrMsgTxt("empty y");
  }
  else if (mx == 0) {
    MAP_OUT = mxCreateDoubleMatrix(my, 1, mxREAL);
    map = mxGetPr(MAP_OUT);
    for (qq = 0; qq < my; qq++)
      map[qq]= NaNValue;
  }
  else if (nx == 1 && ny == 1) {
    /* x and y are 1-D vectors */
    MAP_OUT = mxCreateDoubleMatrix(MAX(my, ny), 1, mxREAL); 
    map = mxGetPr(MAP_OUT);
    for (qq = 0; qq < MAX(my, ny); qq++)  {
      map[qq] = NaNValue;
      for (zz = 0; zz < MAX(mx, nx); zz++) {
	if ( x[zz] == y[qq] ) 
	  map[qq] = zz+1; /* because of matlab's dumb 1-indexing */
      }
    } 
  }
  else if (nx == ny) {
    /* x and y are greater than 1-D */
    MAP_OUT = mxCreateDoubleMatrix(my, 1, mxREAL);
    map = mxGetPr(MAP_OUT);
    for (qq = 0; qq < my; qq++) {
      map[qq] = NaNValue;
      for (zz = 0; zz < mx; zz++) {
	flag = 1;
	kk = 0;
	while (kk < nx && flag == 1) {
	  /* scan each element of the entry, break out on first mismatch */
	  if ( x[mx*kk + zz] != y[my*kk  + qq] )
	    flag = 0;
	  kk++;
	}
	if (flag == 1) /* if it's a match */
	  map[qq] = zz+1;
      }
    }
  }
  else {
    mxErrMsgTxt("size mismatch");
  }
  /*  printf("MEX baby!\n"); */
  return;
    
}
