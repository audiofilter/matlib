/* 
 * This is pwrengine.c, which does the internal double sum
 * of the convolution operation for power calculations
 */
#include <math.h>
#include "mex.h"

/* Input Arguments */

#define	H_IN	prhs[0]
#define	RN_IN	prhs[1]
#define RIDX_IN prhs[2]
#define LOCS_IN prhs[3]

/* Output Arguments */

#define	QT_OUT	plhs[0]

#if !defined(MAX)
#define	MAX(A, B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define	MIN(A, B)	((A) < (B) ? (A) : (B))
#endif

#define PI 3.14159265


int findIndex( double *Ridx, int mRidx, double searchee )
     /* searches Ridx for the index searchee. Since Ridx does not contain
      * duplicates, can stop when first match is found.
      * Note: Ridx is a list of Matlab indices, so take care
      */
{
  int qq;

  for (qq=0; qq<mRidx; qq++) {
    if (Ridx[qq] == searchee)
      return qq;
  }
  return -1; /* error code if index not found */
}

/* --------------------------------------------- */

void rankOneUpdateReal( double *A, double alpha_r, double alpha_i,
			double *x_r, double *x_i,
			double *y_r, double *y_i, int length,
			int hCplexFlag)
     /* This function does the actual computation 
      * Qt = Qt + real(conj(Rn(ll-mm)) * h(:,ll) * h(:,mm)'
      * It is used if full h matrix is sent from Matlab, so
      * only the pointers to the needed columns of h are passed in.
      */
{
  int i, j;
  double cprod1, cprod2;

  if (hCplexFlag == 0) {
    /* if h was purely real, our job is easier.
     * It is necessary to separate these possibilities since h_i 
     * is NULL if h was purely real
     */
    for (i=0; i<length; i++) {
      cprod1 = alpha_r * x_r[i]; /* compute intermediate product once for speed */
      for (j=0; j<length; j++) {
	A[i+j*length] = A[i+j*length] + cprod1*y_r[j]; /* the meat */
      }
    }
  }
  else {
    /* if h is complex */
    for (i=0; i<length; i++) {
      for (j=0; j<length; j++) {
	cprod1 = alpha_r*(x_r[i]*y_r[j] + x_i[i]*y_i[j]);
	cprod2 = alpha_i*(x_i[i]*y_r[j] - x_r[i]*y_i[j] );
	/* Real part of alpha*x[i]*y[j], where all are complex numbers.
	 * Optional: cprod2 can be formed differently so the whole task
	 * takes one fewer multiply
	 */
	A[i+j*length] = A[i+j*length] + cprod1 - cprod2;
      }
    }
  }
  return;
}


/* --------------------------------------------- */

void rankOneUpdateRealSparse( double *A, double alpha_r, double alpha_i,
			      double *h_r, double *h_i,
			      int *h_ir, int *h_jc, 
			      int ll, int mm, int mh, int nh,
			      int hCplexFlag)
{
  int i, j, k;
  double cprod1, cprod2;
  double f1, *f2, xri, xii, *yrj, *yij;
  int rowsLLlength, rowsMMlength;


  /* allocate row lookup tables.
   * For more information on the way MEX does sparse matrices,
   * see the API guide.
   */
  rowsLLlength = h_jc[ll+1] - h_jc[ll];
  /* number of nonzero entries in selected column ll */
  rowsMMlength = h_jc[mm+1] - h_jc[mm];
  /* ditto, for column mm */

  if (hCplexFlag == 0) {
    f2 = mxCalloc(mh, sizeof(double));
    /* if h was purely real, our job is easier.
     * It is necessary to separate these possibilities since h_i 
     * is NULL if h was purely real
     */
    /* search sparse h for second factor (f2). Best to do it out
     * here, instead of in an inner loop. */
    for (j=0; j<mh; j++) {
      f2[j]=0; /* ensures correct value for a column of zeros */
      for (k=0; k<rowsMMlength; k++) {
	if (h_ir[ h_jc[mm]+k ] == j) { /* find desired row j */
	  f2[j] = h_r[h_jc[mm] + k]; /* and copy it into temp array f2 */
	  break; /* escape when entry is found */
	}
      }
    }
    /* main math loop */
    for (i=0; i<mh; i++) {
      /* search for first factor (f1) */
      f1=0;
      for (k=0; k<rowsLLlength; k++) {
	if (h_ir[ h_jc[ll]+k ] == i) {
	  f1 = h_r[h_jc[ll] + k];
	  /* the compiler should be smart enough to put the index
	   * in a register, so for now it is written out twice */
	  break;
	}
      }
      cprod1 = alpha_r*f1; /* compute intermediate product outside j-loop for speed */
      /* perform update */
      for (j=0; j<mh; j++) {
	A[i+j*mh] = A[i+j*mh] + cprod1*f2[j];
      }
    }
  }
  else {
    /* if h is complex */
    yrj = mxCalloc(mh, sizeof(double)); yij = mxCalloc(mh, sizeof(double));
    for (j=0; j<mh; j++) {
      yrj[j]=0; yij[j]=0;
      for (k=0; k<rowsMMlength; k++) {
	if (h_ir[ h_jc[mm]+k ] == j) {
	  /* negative because we take conjugate transpose */
	  /* yrj[j] = -h_r[h_jc[mm] + k]; */
	  /* yij[j] = -h_i[h_jc[mm] + k]; */
	  /* I think the negative is taken care of below. */
          /* Certainly the above gives the wrong answer */
	  yrj[j] = h_r[h_jc[mm] + k];
	  yij[j] = h_i[h_jc[mm] + k];
	  break;
	}
      }
    }
    for (i=0; i<mh; i++) {
      xri=0; xii=0;
      for (k=0; k<rowsLLlength; k++) {
	if (h_ir[ h_jc[ll]+k ] == i) {
	  xri = h_r[h_jc[ll] + k];
	  xii = h_i[h_jc[ll] + k];
	  break; 
	}
      }
      for (j=0; j<mh; j++) {
	cprod1 = alpha_r*(xri*yrj[j] + xii*yij[j]);
	cprod2 = alpha_i*(xii*yrj[j] - xri*yij[j] );
	/* Real part of alpha*x[i]*y[j], where all are complex numbers.
	 * Messy, but that's the way complex multiplication is.
	 */
	A[i+j*mh] = A[i+j*mh] + cprod1 - cprod2;
      }
    }
  }
  return;
}

/* --------------------------------------------- */	

void pwrEngine( double *Qt, 
		double *h_r, double *h_i, int *h_ir, int *h_jc,
	        int mh, int nh, int hSparseFlag,
		double *Rn_r, double *Rn_i,
		double *Ridx, int mRidx,
		double *locs, int mlocs )
{
  int ll, mm, qq, llmm;
  double *op;
  int hCplexFlag = 1;

  /* note: mlocs == nh, since the number of locations equals the number of 
   * columns in the kernel matrix.
   */

  if (h_i == NULL)
    hCplexFlag = 0;

  for (ll=0; ll<mlocs; ll++) {
    for (mm=0; mm<mlocs; mm++) {
      llmm = findIndex(Ridx, mRidx, locs[ll]-locs[mm]); 
      /* find Rn(ll-mm) in vector Rn indexed by Ridx */
      if (llmm == -1)
	mexErrMsgTxt("cryptic error -24: bad return code on findIndex");

      if (hSparseFlag) {
	/* form outer product Rn(ll-mm)*h(:,ll)*h(:,mm)'
	 * use sparse update routine
	 */
	if (Rn_i == NULL) {
	  rankOneUpdateRealSparse(Qt, Rn_r[llmm], (double)0, 
				  h_r, h_i, h_ir, h_jc, ll, mm,
				  mh, nh, hCplexFlag);
	}
	else {
	  rankOneUpdateRealSparse(Qt, Rn_r[llmm], -Rn_i[llmm], 
				  h_r, h_i, h_ir, h_jc, ll, mm, 
				  mh, nh, hCplexFlag);
	}
      }
      else { /* if h is full */
	if (Rn_i == NULL) {
	  rankOneUpdateReal(Qt, Rn_r[llmm], (double)0,
			    h_r+ll*mh, h_i+ll*mh,
			    h_r+mm*mh, h_i+mm*mh, mh, hCplexFlag);
	}
	else {
	  rankOneUpdateReal(Qt, Rn_r[llmm], -Rn_i[llmm],
			    h_r+ll*mh, h_i+ll*mh,
			    h_r+mm*mh, h_i+mm*mh,
			    mh, hCplexFlag);
	}
	/* form outer product Rn(ll-mm)*h(:,ll)*h(:,mm)'
	 * Luckily the matrix is stored column major so the columns I
	 * want to extract are stored contiguously. So I can use simple
	 * pointer addition.
	 */

      }
    }
  }
  return;
}

/* --------------------------------------------- */
	       
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )     
{ 
  double *h_r, *h_i;
  int *h_ir, *h_jc; 
  double *Rn_r, *Rn_i; 
  double *Ridx, *locs;
  double *Qt;
  int mh, nh, nzmaxh, hSparseFlag, mlocs, mRidx;
  int qq, zz, kk;	    /* loop indexes */ 
  int flag;
  double NaNValue = mxGetNaN();
    
  /* Check for proper number of arguments */    
  if (nrhs != 4) { 
    mexErrMsgTxt("Four input arguments required."); 
  } 
  else if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments."); 
  } 
    
  /* Get size of parameters */
  mh = mxGetM(H_IN); 
  nh = mxGetN(H_IN);
  nzmaxh = mxGetNzmax(H_IN); /* since h can be sparse */
  hSparseFlag = mxIsSparse(H_IN);
  mlocs = mxGetM(LOCS_IN);
  mRidx = mxGetM(RIDX_IN);
  /* printf("sizes: mh = %d, nh = %d, mlocs = %d, mRidx = %d\n", mh, nh, mlocs, mRidx);
     if (hSparseFlag) printf("Sparse version used.\n"); */

  /* Assign pointers to the various parameters */ 
  h_r = mxGetPr(H_IN); h_i = mxGetPi(H_IN); 
  h_ir = mxGetIr(H_IN); h_jc = mxGetJc(H_IN);
  Rn_r = mxGetPr(RN_IN); Rn_i = mxGetPi(RN_IN);
  Ridx = mxGetPr(RIDX_IN);
  locs = mxGetPr(LOCS_IN);

  if (mxIsComplex(H_IN)) printf("Complex h.\n");
 
  /* Create a matrix for the return argument */ 
  QT_OUT = mxCreateDoubleMatrix(mh, mh, mxREAL); 
  Qt = mxGetPr(QT_OUT);

  pwrEngine(Qt, h_r, h_i, h_ir, h_jc, mh, nh, hSparseFlag,
	    Rn_r, Rn_i,  Ridx, mRidx, locs, mlocs);

  /*  printf("MEX baby!\n"); */
  return;
}
