/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_eL_1Loss_gen_mex.c
 *
 * Code generation for function '_coder_eL_1Loss_gen_mex'
 *
 */

/* Include files */
#include "_coder_eL_1Loss_gen_mex.h"
#include "_coder_eL_1Loss_gen_api.h"
#include "eL_1Loss_gen_data.h"
#include "eL_1Loss_gen_initialize.h"
#include "eL_1Loss_gen_terminate.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void eL_1Loss_gen_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T nrhs,
                              const mxArray *prhs[2])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 2, 4,
                        12, "eL_1Loss_gen");
  }
  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 12,
                        "eL_1Loss_gen");
  }
  /* Call the function. */
  eL_1Loss_gen_api(prhs, &outputs);
  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, &plhs[0], &outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&eL_1Loss_gen_atexit);
  /* Module initialization. */
  eL_1Loss_gen_initialize();
  /* Dispatch the entry-point. */
  eL_1Loss_gen_mexFunction(nlhs, plhs, nrhs, prhs);
  /* Module termination. */
  eL_1Loss_gen_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2021a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_eL_1Loss_gen_mex.c) */
