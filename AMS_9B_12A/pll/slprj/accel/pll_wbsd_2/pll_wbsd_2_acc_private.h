#include "__cf_pll_wbsd_2.h"
#ifndef RTW_HEADER_pll_wbsd_2_acc_private_h_
#define RTW_HEADER_pll_wbsd_2_acc_private_h_
#include "rtwtypes.h"
#ifndef RTW_COMMON_DEFINES_
#define RTW_COMMON_DEFINES_
#define rt_VALIDATE_MEMORY(S, ptr)   if(!(ptr)) {\
  ssSetErrorStatus(S, RT_MEMORY_ALLOCATION_ERROR);\
  }
#if !defined(_WIN32)
#define rt_FREE(ptr)   if((ptr) != (NULL)) {\
  free((ptr));\
  (ptr) = (NULL);\
  }
#else
#define rt_FREE(ptr)   if((ptr) != (NULL)) {\
  free((void *)(ptr));\
  (ptr) = (NULL);\
  }
#endif
#endif
#ifndef __RTWTYPES_H__
#error This file requires rtwtypes.h to be included
#else
#ifdef TMWTYPES_PREVIOUSLY_INCLUDED
#error This file requires rtwtypes.h to be included before tmwtypes.h
#else
#ifndef RTWTYPES_ID_C08S16I32L32N32F1
#error This code was generated with a different "rtwtypes.h" than the file included
#endif
#endif
#endif
extern uint32_T MWDSP_EPH_R_D ( real_T evt , uint32_T * sta ) ; void
pll_wbsd_2_Accumulator1_Init ( SimStruct * const S ,
rtDW_Accumulator1_pll_wbsd_2 * localDW , rtP_Accumulator1_pll_wbsd_2 * localP
) ; void pll_wbsd_2_Accumulator1_Update ( SimStruct * const S ,
rtB_Accumulator1_pll_wbsd_2 * localB , rtDW_Accumulator1_pll_wbsd_2 * localDW
) ; void pll_wbsd_2_Accumulator1 ( SimStruct * const S , real_T rtu_In ,
rtB_Accumulator1_pll_wbsd_2 * localB , rtDW_Accumulator1_pll_wbsd_2 * localDW
, rtP_Accumulator1_pll_wbsd_2 * localP ) ; void pll_wbsd_2_DFlipFlop_Disable
( SimStruct * const S , rtB_DFlipFlop_pll_wbsd_2 * localB ,
rtDW_DFlipFlop_pll_wbsd_2 * localDW , rtP_DFlipFlop_pll_wbsd_2 * localP ) ;
void pll_wbsd_2_DFlipFlop ( SimStruct * const S , real_T rtu_0 , real_T rtu_1
, real_T rtu_2 , rtB_DFlipFlop_pll_wbsd_2 * localB ,
rtDW_DFlipFlop_pll_wbsd_2 * localDW , rtP_DFlipFlop_pll_wbsd_2 * localP ,
rtZCE_DFlipFlop_pll_wbsd_2 * localZCE ) ; void pll_wbsd_2_SpectrumScope_Init
( SimStruct * const S ) ; void pll_wbsd_2_SpectrumScope_Update ( SimStruct *
const S ) ; void pll_wbsd_2_SpectrumScope ( SimStruct * const S ) ; void
pll_wbsd_2_SpectrumScope_Term ( SimStruct * const S ) ;
#endif
