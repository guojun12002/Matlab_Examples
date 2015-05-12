#include "__cf_pll_wbsd_2.h"
#ifndef RTW_HEADER_pll_wbsd_2_acc_h_
#define RTW_HEADER_pll_wbsd_2_acc_h_
#ifndef pll_wbsd_2_acc_COMMON_INCLUDES_
#define pll_wbsd_2_acc_COMMON_INCLUDES_
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#define S_FUNCTION_NAME simulink_only_sfcn 
#define S_FUNCTION_LEVEL 2
#define RTW_GENERATED_S_FUNCTION
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "HostLib_FFT.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"
#include "rt_defines.h"
#include "rt_zcfcn.h"
#endif
#include "pll_wbsd_2_acc_types.h"
typedef struct { real_T B_4_0_0 ; real_T B_4_1_0 ; real_T B_4_2_0 ; real_T
B_4_3_0 ; real_T B_4_4_0 ; } rtB_Accumulator1_pll_wbsd_2 ; typedef struct {
real_T UnitDelay_DSTATE ; } rtDW_Accumulator1_pll_wbsd_2 ; typedef struct {
real_T B_7_0_0 ; real_T B_7_1_0 ; } rtB_DFlipFlop_pll_wbsd_2 ; typedef struct
{ int8_T DFlipFlop_SubsysRanBC ; boolean_T DFlipFlop_MODE ; char
pad_DFlipFlop_MODE [ 6 ] ; } rtDW_DFlipFlop_pll_wbsd_2 ; typedef struct {
real_T DFlipFlop_Trig_ZC ; } rtZCSV_DFlipFlop_pll_wbsd_2 ; typedef struct {
ZCSigState DFlipFlop_Trig_ZCE ; } rtZCE_DFlipFlop_pll_wbsd_2 ; typedef struct
{ creal_T B_10_3_0 [ 256 ] ; real_T B_11_0_0 ; real_T B_11_1_0 ; real_T
B_11_2_0 ; real_T B_11_3_0 ; real_T B_11_4_0 ; real_T B_11_5_0 ; real_T
B_11_6_0 ; real_T B_11_7_0 ; real_T B_11_8_0 ; real_T B_11_9_0 ; real_T
B_11_10_0 ; real_T B_11_11_0 ; real_T B_11_12_0 ; real_T B_11_13_0 ; real_T
B_11_14_0 ; real_T B_11_15_0 ; real_T B_11_17_0 ; real_T B_11_19_0 ; real_T
B_11_21_0 ; real_T B_11_22_0 ; real_T B_11_23_0 ; real_T B_11_24_0 ; real_T
B_11_26_0 ; real_T B_11_27_0 ; real_T B_11_28_0 ; real_T B_11_29_0 ; real_T
B_11_30_0 ; real_T B_11_31_0 ; real_T B_11_32_0 ; real_T B_11_33_0 ; real_T
B_11_35_0 ; real_T B_11_36_0 ; real_T B_11_38_0 ; real_T B_11_39_0 ; real_T
B_11_40_0 ; real_T B_11_41_0 ; real_T B_11_42_0 ; real_T B_11_45_0 ; real_T
B_11_46_0 ; real_T B_11_47_0 ; real_T B_11_48_0 ; real_T B_11_52_0 ; real_T
B_11_53_0 ; real_T B_11_54_0 ; real_T B_11_55_0 ; real_T B_11_56_0 ; real_T
B_11_58_0 ; real_T B_11_59_0 ; real_T B_11_60_0 ; real_T B_11_62_0 ; real_T
B_11_63_0 ; real_T B_11_64_0 ; real_T B_10_0_0 [ 256 ] ; real_T B_10_1_0 [
256 ] ; real_T B_10_2_0 [ 256 ] ; real_T B_10_2_1 [ 256 ] ; real_T B_10_4_0 [
256 ] ; real_T B_10_5_0 [ 256 ] ; real_T B_10_6_0 ; real_T B_10_7_0 ; real_T
B_10_8_0 ; real_T B_10_9_0 [ 256 ] ; real_T B_9_0_0 ; real_T B_6_2_0 ; real_T
B_6_3_0 ; real_T B_6_4_0 ; real_T B_6_5_0 ; real_T B_6_6_0 ; real_T B_6_7_0 ;
real_T B_6_8_0 ; real_T B_6_9_0 ; real_T B_6_10_0 ; real_T B_3_0_0 ; real_T
B_3_1_0 ; real_T B_2_0_0 ; real_T B_2_1_0 ; real_T B_2_2_0 ; real_T B_2_3_0 ;
real_T B_2_4_0 ; real_T B_1_0_0 ; real_T B_0_0_0 ; rtB_DFlipFlop_pll_wbsd_2
DFlipFlop ; rtB_DFlipFlop_pll_wbsd_2 DFlipFlop_j ;
rtB_Accumulator1_pll_wbsd_2 Accumulator2 ; rtB_Accumulator1_pll_wbsd_2
Accumulator1 ; } BlockIO_pll_wbsd_2 ; typedef struct { real_T Buffer_CircBuf
[ 512 ] ; real_T DigitalFilter_FILT_STATES [ 256 ] ; real_T Delay1_IC_BUFF ;
real_T Delay3_IC_BUFF ; real_T Delay5_IC_BUFF ; real_T Delay7_IC_BUFF ;
real_T UnitDelay_DSTATE ; real_T
TmpLatchAtFrequencyDividerInport1_PreviousInput ; real_T IC_FirstOutputTime ;
real_T TmpLatchAtDFlipFlopInport1_PreviousInput ; real_T Memory_PreviousInput
; real_T TmpLatchAtDFFInport1_PreviousInput ; real_T
TmpLatchAtDFlipFlopInport1_PreviousInput_a ; real_T FFT_HostLib [ 137 ] ;
struct { void * LoggedData ; } VCOIn_PWORK ; void * FrameScope_PWORK [ 3 ] ;
int32_T Buffer_inBufPtrIdx ; int32_T Buffer_outBufPtrIdx ; int32_T
Buffer_bufferLength ; int32_T DigitalFilter_CIRCBUFFIDX ; uint32_T
Counter_ClkEphState ; uint32_T Counter_RstEphState ; struct { int_T
IcNeedsLoading ; } Integrator_IWORK ; int_T Abs_MODE ; int8_T
FrequencyDivider_SubsysRanBC ; int8_T MultiStageNoiseShaping_SubsysRanBC ;
int8_T SampleandHold_SubsysRanBC ; int8_T DFF_SubsysRanBC ; uint8_T
Counter_Count ; boolean_T RelationalOperator_Mode ; boolean_T
RelationalOperator_Mode_e ; boolean_T RelationalOperator_Mode_j ; boolean_T
Window_FLAG ; char pad_Window_FLAG [ 7 ] ; rtDW_DFlipFlop_pll_wbsd_2
DFlipFlop ; rtDW_DFlipFlop_pll_wbsd_2 DFlipFlop_j ;
rtDW_Accumulator1_pll_wbsd_2 Accumulator2 ; rtDW_Accumulator1_pll_wbsd_2
Accumulator1 ; } D_Work_pll_wbsd_2 ; typedef struct { real_T
Integrator_CSTATE ; real_T antialias_CSTATE [ 8 ] ; real_T
Integrator_CSTATE_k ; real_T LoopFilter_CSTATE ; }
ContinuousStates_pll_wbsd_2 ; typedef struct { real_T Integrator_CSTATE ;
real_T antialias_CSTATE [ 8 ] ; real_T Integrator_CSTATE_k ; real_T
LoopFilter_CSTATE ; } StateDerivatives_pll_wbsd_2 ; typedef struct {
boolean_T Integrator_CSTATE ; boolean_T antialias_CSTATE [ 8 ] ; boolean_T
Integrator_CSTATE_k ; boolean_T LoopFilter_CSTATE ; }
StateDisabled_pll_wbsd_2 ; typedef struct { real_T Abs_AbsZc_ZC ; real_T
RelationalOperator_RelopInput_ZC ; real_T Integrator_Reset_ZC ; real_T
RelationalOperator_RelopInput_ZC_b ; real_T
RelationalOperator_RelopInput_ZC_b0 ; real_T SampleandHold_Trig_ZC ;
rtZCSV_DFlipFlop_pll_wbsd_2 DFlipFlop ; rtZCSV_DFlipFlop_pll_wbsd_2
DFlipFlop_j ; real_T MultiStageNoiseShaping_Trig_ZC ; real_T DFF_Trig_ZC ;
real_T FrequencyDivider_Trig_ZC ; } ZCSignalValues_pll_wbsd_2 ; typedef
struct { ZCSigState Abs_AbsZc_ZCE ; ZCSigState
RelationalOperator_RelopInput_ZCE ; ZCSigState Integrator_Reset_ZCE ;
ZCSigState RelationalOperator_RelopInput_ZCE_j ; ZCSigState
RelationalOperator_RelopInput_ZCE_c ; ZCSigState SampleandHold_Trig_ZCE ;
rtZCE_DFlipFlop_pll_wbsd_2 DFlipFlop ; rtZCE_DFlipFlop_pll_wbsd_2 DFlipFlop_j
; ZCSigState MultiStageNoiseShaping_Trig_ZCE ; ZCSigState DFF_Trig_ZCE ;
ZCSigState FrequencyDivider_Trig_ZCE ; } PrevZCSigStates_pll_wbsd_2 ; typedef
struct { real_T pooled1 ; real_T Window_WindowSamples [ 256 ] ; uint8_T
Counter_Direction ; uint8_T Counter_MaximumCount ; char
pad_Counter_MaximumCount [ 6 ] ; } ConstParam_pll_wbsd_2 ; struct
rtP_Accumulator1_pll_wbsd_2_ { real_T P_0 ; real_T P_1 ; } ; struct
rtP_DFlipFlop_pll_wbsd_2_ { real_T P_0 ; real_T P_1 ; } ; struct
Parameters_pll_wbsd_2_ { real_T P_0 ; real_T P_1 ; real_T P_2 ; real_T P_3 ;
real_T P_4 ; real_T P_5 ; real_T P_6 ; real_T P_7 ; real_T P_8 ; real_T P_9 ;
real_T P_10 ; real_T P_11 ; real_T P_12 ; real_T P_13 ; real_T P_14 ; real_T
P_15 ; real_T P_16 ; real_T P_17 ; real_T P_18 [ 24 ] ; real_T P_19 [ 4 ] ;
real_T P_20 [ 8 ] ; real_T P_21 ; real_T P_22 ; real_T P_24 ; real_T P_25 ;
real_T P_28 ; real_T P_29 ; real_T P_30 ; real_T P_31 ; real_T P_32 ; real_T
P_33 ; real_T P_34 ; real_T P_35 ; real_T P_36 ; real_T P_37 ; real_T P_38 ;
real_T P_40 ; real_T P_41 ; real_T P_42 ; real_T P_43 ; real_T P_44 ; real_T
P_45 ; real_T P_46 ; real_T P_47 ; real_T P_48 ; uint8_T P_49 ; uint8_T P_50
; char pad_P_50 [ 6 ] ; rtP_DFlipFlop_pll_wbsd_2 DFlipFlop ;
rtP_DFlipFlop_pll_wbsd_2 DFlipFlop_j ; rtP_Accumulator1_pll_wbsd_2
Accumulator2 ; rtP_Accumulator1_pll_wbsd_2 Accumulator1 ; } ; extern
Parameters_pll_wbsd_2 pll_wbsd_2_rtDefaultParameters ; extern const
ConstParam_pll_wbsd_2 pll_wbsd_2_rtConstP ;
#endif
