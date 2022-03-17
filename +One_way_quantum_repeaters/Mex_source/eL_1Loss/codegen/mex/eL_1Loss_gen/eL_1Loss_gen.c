/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eL_1Loss_gen.c
 *
 * Code generation for function 'eL_1Loss_gen'
 *
 */

/* Include files */
#include "eL_1Loss_gen.h"
#include "rt_nonfinite.h"
#include "eL_1Loss.h"

/* Function Definitions */
real_T eL_1Loss_gen(const emlrtStack *sp, real_T z, real_T t)
{
  (void)sp;
  /*  Derived using logical ket(+) state and qubits lost are [qubit1] */
  /*  with error syndrome 0. */
  /*  The full 9-qubit circuit was used to derive the expression. */
  /*  z is e0. */
  /*  t is etrans. */
  return eL_1Loss(z, t);
}

/* End of code generation (eL_1Loss_gen.c) */
