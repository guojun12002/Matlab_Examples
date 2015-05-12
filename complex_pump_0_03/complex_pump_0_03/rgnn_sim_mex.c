#include "mex.h"
#include "math.h"

/*Y_hat=rgnn_sim_mex(U,W,activations,x)*/

//%
//%Copyright (c) 2009, Travis Wiens
///%All rights reserved.
//%
//%Redistribution and use in source and binary forms, with or without 
//%modification, are permitted provided that the following conditions are 
//%met:
//%
//%    * Redistributions of source code must retain the above copyright 
//%      notice, this list of conditions and the following disclaimer.
//%    * Redistributions in binary form must reproduce the above copyright 
//%      notice, this list of conditions and the following disclaimer in 
//%      the documentation and/or other materials provided with the distribution
//%      
//%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
///%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
//%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
//%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
//%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
//%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
//%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//%POSSIBILITY OF SUCH DAMAGE.
//%
//% If you would like to request that this software be licensed under a less
//% restrictive license (i.e. for commercial closed-source use) please
//% contact Travis at travis.mlfx@nutaksas.com

double fast_tanh(double x)
{
	double x_tmp;
	x_tmp=exp(2*x);
	return (x_tmp-1)/(x_tmp+1);
}

double sigmoid(double x)
{
	return 1/(1+exp(-x));
}

double linear(double x)
{
	return x;
	
}

double squash(double x)
{
	return 0.5+0.5*x/(((x<0)?-1:1)*x+1);
}

double dsigmoid(double x)
{
	return x*(1-x);
}

double dtanh(double x)
{
	return 1-x*x;
}

double dsquash(double x)
{
	double x_tmp;
	x_tmp=(x<0.5)?(x):(1-x);
	return 2*x_tmp*x_tmp;	
}

double tanhtaylor1(double x)
{
	return x/(((x<0)?-1:1)*x+1);
}

double dtanhtaylor1(double x)
{
	double x_tmp;
	x_tmp=1-(((x<0)?-1:1)*x);
	return x_tmp*x_tmp;
}

double alg_sigmoid(double x)
{
	return x/sqrt(1+x*x);
}

double dalg_sigmoid(double x)
{
	double x_tmp;
	x_tmp=1-x*x;
	return x_tmp*sqrt(x_tmp);
}

void sim_rgnn_activations(double *y_hat, double *x, double *net, double *u, double *W, unsigned int N_neurons, unsigned int N_inputs, double *activations)
{
	unsigned int i,j;
    
	for (i=0;i<N_inputs;i++)
	{
		*(x+i)=*(u+i); 
	}
	for (i=N_inputs;i<N_neurons;i++)
	{
		*(net+i)=0;
		for (j=0;j<N_neurons;j++)
		{			
			*(net+i)=*(net+i)+*(W+j*N_neurons+i)**(x+j);
		}
		switch((int)*(activations+i))
		{
			case 0:
				/* *(x+i)=1/(1+exp(-*(net+i)));*/
				*(x+i)=sigmoid(*(net+i));
				break;
			case 1:
				*(x+i)=tanh(*(net+i));
				break;
			case 2:
				*(x+i)=linear(*(net+i));/*this is just to make sure the function overhead is fair
				break;*/
				break;
			case 3:
				*(x+i)=tanhtaylor1(*(net+i));
				break;
			case 4:
				*(x+i)=squash(*(net+i));
				break;

			case 5:
				*(x+i)=alg_sigmoid(*(net+i));
				break;
			case 6:
				*(x+i)=fast_tanh(*(net+i));
				break;
			default:
				printf("Error: activation %d not supported",*(activations+i));
				break;
		}
	}
    	*(y_hat)=*(x+N_neurons-1);
	return;

}


/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double *pU,*pW;
  double *pactivation;
  double *px_in;
  double *pY_hat;

  double *pu,*py_hat,*pnet,*px;
  int ncols,mrows;
  unsigned int N_points,N_inputs, N_neurons;
  int i,j;
  
  if (nrhs <4 ) 
    mexErrMsgTxt("Four inputs required.");
  if (nlhs != 1) 
    mexErrMsgTxt("One outputs required.");

  /* Create a pointer to the input matrices. */
  pU = mxGetPr(prhs[0]);
  pW = mxGetPr(prhs[1]);
  pactivation = mxGetPr(prhs[2]);
  px_in= mxGetPr(prhs[3]);
  
  /* Get the dimensions of the matrix input u_s. */
  N_points = mxGetN(prhs[0]);
  N_inputs = mxGetM(prhs[0]);
  
  N_neurons = mxGetN(prhs[1]);

  /* Set the output pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(1, N_points, mxREAL);/*w*/
  
  /* Create a C pointer to a copy of the output matrix. */
  pY_hat = mxGetPr(plhs[0]);
  
  /* Call the C subroutine. */

  pu=(double *) calloc(N_inputs,sizeof(double));
  pnet=(double *) calloc(N_neurons,sizeof(double));
  px=(double *) calloc(N_neurons,sizeof(double));
  py_hat=(double *) calloc(1,sizeof(double));
  for(i=0;i<N_neurons;i++)
  {
	  *(px+i)=*(px_in+i);
  }
  
  /*iterate points algorithm*/
  for (i=0;i<N_points;i++)
  {
      for (j=0;j<N_inputs;j++)
	{
		*(pu+j)=*(pU+i*N_inputs+j);
	}
	
      sim_rgnn_activations(py_hat, px, pnet, pu, pW, N_neurons, N_inputs, pactivation);
      
      *(pY_hat+i)=*py_hat;
  }
  free(pu);
  free(pnet);
  free(px);
  free(py_hat);
}
