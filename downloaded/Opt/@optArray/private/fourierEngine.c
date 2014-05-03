#include <math.h>
#include "mex.h"

/* Input Arguments */

#define	H_IN         prhs[0]
#define LOCS_IN      prhs[1]
#define	F_IN         prhs[2]

/* Output Arguments */

#define	GH_OUT	plhs[0]

#if !defined(MAX)
#define	MAX(A, B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define	MIN(A, B)	((A) < (B) ? (A) : (B))
#endif

#define PI 3.14159265

void fullEngine(double *Gh_r, double *Gh_i,
		double *h_r, double *h_i, unsigned int mh,
		double *locs, unsigned int mlocs, unsigned int dim,
		double *f, unsigned int mf,
		unsigned int hCplexFlag)
{
  unsigned int qq, zz, ff, tau, kk;    /* loop indexes */ 
  double dotProd, exponent, sinExp, cosExp;

  /* 
   * find Fourier transform using
   * H(f) = SUM_tau  h(tau) exp(-j*2*pi*<f,tau>)
   */
  for (ff=0; ff<mf; ff++) { /* loop over frequencies */
    for (tau=0; tau<mlocs; tau++) { /* loop over locs */
      dotProd = 0;
      for (kk=0; kk<dim; kk++) {
	/* form dot product <f,tau> */
	dotProd = dotProd + f[ff+kk*mf] * locs[tau+kk*mlocs];
      }
      exponent = -2 * PI * dotProd;
      for (qq=0; qq<mh; qq++) {
	/* form output vector H(f) */
	/* exponentiation by the Euler identity */
	if (hCplexFlag) {
	  sinExp = sin(exponent); cosExp = cos(exponent);
	  Gh_r[qq+ff*mh] += h_r[qq+tau*mh] * cosExp  -  h_i[qq+tau*mh] * sinExp   ;
	  Gh_i[qq+ff*mh] += h_r[qq+tau*mh] * sinExp  +  h_i[qq+tau*mh] * cosExp ;
	}
	else {
	  Gh_r[qq+ff*mh] += h_r[qq+tau*mh] * cos(exponent);
	  Gh_i[qq+ff*mh] += h_r[qq+tau*mh] * sin(exponent);
	}
      }
    }
  }

  return;
}

/* ---------------------------------------------- */

void sparseEngine(double *Gh_r, double *Gh_i,
		  double *h_r, double *h_i, unsigned int mh,
		  int *h_ir, int *h_jc,
		  double *locs, unsigned int mlocs, unsigned int dim,
		  double *f, unsigned int mf,
		  unsigned int hCplexFlag)
{
  unsigned int qq, zz, ff, tau, kk;    /* loop indexes */ 
  double dotProd, exponent, sinExp, cosExp;
  int colHeight, rowNow, idxNow;
  /* 
   * For more information on the way MEX does sparse matrices,
   * see the API guide.
   */

  /* 
   * find Fourier transform using
   * H(f) = SUM_tau  h(tau) exp(-j*2*pi*<f,tau>)
   */
  for (ff=0; ff<mf; ff++) { /* loop over frequencies */
    for (tau=0; tau<mlocs; tau++) { /* loop over locs */
      colHeight = h_jc[tau+1] - h_jc[tau];
      /* number of nonzero entries in column tau of h */
      dotProd = 0;
      for (kk=0; kk<dim; kk++) {
	/* form dot product <f,tau> */
	dotProd = dotProd + f[ff+kk*mf] * locs[tau+kk*mlocs];
      }
      exponent = -2 * PI * dotProd;
      for (qq=0, idxNow = h_jc[tau];
	   qq<colHeight; 
	   qq++, idxNow++) {
	/* form output vector H(f) */
	rowNow = h_ir[idxNow];
	/* exponentiation by the Euler identity */
	if (hCplexFlag) {
	  sinExp = sin(exponent); cosExp = cos(exponent);
	  Gh_r[rowNow+ff*mh] += 
	    h_r[idxNow] * cosExp  -  h_i[idxNow] * sinExp   ;
	  Gh_i[rowNow+ff*mh] += 
	    h_r[idxNow] * sinExp  +  h_i[idxNow] * cosExp ;
	}
	else {
	  Gh_r[rowNow+ff*mh] += h_r[idxNow] * cos(exponent);
	  Gh_i[rowNow+ff*mh] += h_r[idxNow] * sin(exponent);
	}
      }
    }
  }

  return;

}


/* ---------------------------------------------- */

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )     
{ 
  double *h_r, *h_i;
  int *h_ir, *h_jc;
  double *f, *locs;
  double *Gh_r, *Gh_i;
  unsigned int mh, mlocs, mf, dim;
  double NaNValue = mxGetNaN();
  unsigned int hCplexFlag, hSparseFlag;
    
  /* Get size of inputs */
  mh = mxGetM(H_IN); 
  mlocs = mxGetN(H_IN);
  mf = mxGetM(F_IN);
  dim = mxGetN(F_IN);

  /* Assign pointers to the various parameters */ 
  h_r = mxGetPr(H_IN);
  h_i = mxGetPi(H_IN);
  locs = mxGetPr(LOCS_IN);
  f = mxGetPr(F_IN);

  h_ir = mxGetIr(H_IN); h_jc = mxGetJc(H_IN);

  hSparseFlag = mxIsSparse(H_IN);
  hCplexFlag = mxIsComplex(H_IN);
  if (hSparseFlag) printf("FOURIER: Sparse version used.\n");
  if (hCplexFlag) printf("FOURIER: Complex h.\n");
  printf("FOURIER: array is %d x %d, vars: %d, freqs: %d\n", 
	 mlocs, dim, mh, mf);

  /* Create a vector for the return argument */ 
  GH_OUT = mxCreateDoubleMatrix(mh, mf, mxCOMPLEX);
  /* this double matrix is initialized to 0 automatically */
  Gh_r = mxGetPr(GH_OUT);
  Gh_i = mxGetPi(GH_OUT);

  if (hSparseFlag)
    sparseEngine( Gh_r,  Gh_i,
		  h_r,  h_i,  mh,
		  h_ir, h_jc,
		  locs,  mlocs,  dim,
		  f,  mf,
		  hCplexFlag );
  else
    fullEngine( Gh_r,  Gh_i,
		h_r,  h_i,  mh,
		locs,  mlocs,  dim,
		f,  mf,
		hCplexFlag );

  return;
}

