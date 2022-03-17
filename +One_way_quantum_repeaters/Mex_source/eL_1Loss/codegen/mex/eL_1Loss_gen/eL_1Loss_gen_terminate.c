/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eL_1Loss_gen_terminate.c
 *
 * Code generation for function 'eL_1Loss_gen_terminate'
 *
 */

/* Include files */
#include "eL_1Loss_gen_terminate.h"
#include "_coder_eL_1Loss_gen_mex.h"
#include "eL_1Loss_gen_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void eL_1Loss_gen_atexit(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void eL_1Loss_gen_terminate(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (eL_1Loss_gen_terminate.c) */
