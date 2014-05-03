#include <math.h>
#include "mex.h"

/* Input Arguments */

#define	T_IN    	prhs[0]
#define	FREQS_IN	prhs[2]
#define COEFF_IN        prhs[3]

/* Output Arguments */

#define	R_OUT	plhs[0]

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
  double *t; 
  double *freqs; 
  double *Coeff;
  double *r_r, *r_i;
  double dotProd;
  unsigned int mt, n, mf;
  unsigned int qq, zz, kk;	    /* loop indexes */ 
  double NaNValue = mxGetNaN();
    
  /* Get size of inputs */
  mt = mxGetM(T_IN); 
  n  = mxGetN(T_IN);
  mf = mxGetM(FREQS_IN); 

  /* Assign pointers to the various parameters */ 
  t = mxGetPr(T_IN); 
  freqs = mxGetPr(FREQS_IN);
  Coeff = mxGetPr(COEFF_IN);

  /* Create a vector for the return argument */ 
  R_OUT = mxCreateDoubleMatrix(mt, 1, mxCOMPLEX);
  /* this double matrix is initialized to 0 automatically */
  r_r = mxGetPr(R_OUT);
  r_i = mxGetPi(R_OUT);

  for (qq=0; qq<mt; qq++) {
    for (zz=0; zz<mf; zz++) {
      dotProd = 0;
      for (kk = 0; kk<n; kk++) {
	/* form dot product <t, offset> */
	dotProd = dotProd + t[qq+mt*kk] * freqs[zz+mf*kk];
      }
      /* exponentiation by the Euler identity */
      r_r[qq] = r_r[qq] + Coeff[zz] * cos(2*PI*dotProd);
      r_i[qq] = r_i[qq] + Coeff[zz] * sin(2*PI*dotProd);
    }
  }

  return;
    
}
