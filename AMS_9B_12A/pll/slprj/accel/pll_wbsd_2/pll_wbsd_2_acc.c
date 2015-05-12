#include "__cf_pll_wbsd_2.h"
#include <math.h>
#include "pll_wbsd_2_acc.h"
#include "pll_wbsd_2_acc_private.h"
#include <stdio.h>
#include "simstruc.h"
#include "fixedpoint.h"
#define CodeFormat S-Function
#define AccDefine1 Accelerator_S-Function
void pll_wbsd_2_Accumulator1_Init ( SimStruct * const S ,
rtDW_Accumulator1_pll_wbsd_2 * localDW , rtP_Accumulator1_pll_wbsd_2 * localP
) { localDW -> UnitDelay_DSTATE = localP -> P_1 ; } void
pll_wbsd_2_Accumulator1 ( SimStruct * const S , real_T rtu_In ,
rtB_Accumulator1_pll_wbsd_2 * localB , rtDW_Accumulator1_pll_wbsd_2 * localDW
, rtP_Accumulator1_pll_wbsd_2 * localP ) { localB -> B_4_0_0 = localP -> P_0
; localB -> B_4_1_0 = localDW -> UnitDelay_DSTATE ; localB -> B_4_2_0 =
localB -> B_4_1_0 + rtu_In ; localB -> B_4_3_0 = muDoubleScalarMod ( localB
-> B_4_2_0 , localB -> B_4_0_0 ) ; localB -> B_4_4_0 = ( real_T ) ( localB ->
B_4_2_0 >= localB -> B_4_0_0 ) ; } void pll_wbsd_2_Accumulator1_Update (
SimStruct * const S , rtB_Accumulator1_pll_wbsd_2 * localB ,
rtDW_Accumulator1_pll_wbsd_2 * localDW ) { localDW -> UnitDelay_DSTATE =
localB -> B_4_3_0 ; } void pll_wbsd_2_DFlipFlop_Disable ( SimStruct * const S
, rtB_DFlipFlop_pll_wbsd_2 * localB , rtDW_DFlipFlop_pll_wbsd_2 * localDW ,
rtP_DFlipFlop_pll_wbsd_2 * localP ) { localB -> B_7_0_0 = localP -> P_0 ;
localB -> B_7_1_0 = localP -> P_1 ; localDW -> DFlipFlop_MODE = FALSE ; }
void pll_wbsd_2_DFlipFlop ( SimStruct * const S , real_T rtu_0 , real_T rtu_1
, real_T rtu_2 , rtB_DFlipFlop_pll_wbsd_2 * localB ,
rtDW_DFlipFlop_pll_wbsd_2 * localDW , rtP_DFlipFlop_pll_wbsd_2 * localP ,
rtZCE_DFlipFlop_pll_wbsd_2 * localZCE ) { if ( rtu_0 > 0.0 ) { if ( ! localDW
-> DFlipFlop_MODE ) { if ( ssGetTaskTime ( S , 1 ) != ssGetTStart ( S ) ) {
ssSetSolverNeedsReset ( S ) ; } localDW -> DFlipFlop_MODE = TRUE ; } if (
ssIsMajorTimeStep ( S ) && ( rt_ZCFcn ( RISING_ZERO_CROSSING , & localZCE ->
DFlipFlop_Trig_ZCE , ( rtu_1 ) ) != NO_ZCEVENT ) ) { localB -> B_7_0_0 =
rtu_2 ; localB -> B_7_1_0 = ( real_T ) ! ( localB -> B_7_0_0 != 0.0 ) ;
localDW -> DFlipFlop_SubsysRanBC = 4 ; } } else { if ( localDW ->
DFlipFlop_MODE ) { ssSetSolverNeedsReset ( S ) ; pll_wbsd_2_DFlipFlop_Disable
( S , localB , localDW , localP ) ; } localZCE -> DFlipFlop_Trig_ZCE = (
uint8_T ) ( rtu_1 < 0.0 ? ( int32_T ) NEG_ZCSIG : rtu_1 > 0.0 ? ( int32_T )
POS_ZCSIG : ( int32_T ) ZERO_ZCSIG ) ; } } void pll_wbsd_2_SpectrumScope_Init
( SimStruct * const S ) { int32_T i ; D_Work_pll_wbsd_2 * _rtDW ; _rtDW = ( (
D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) ) ; for ( i = 0 ; i < 512 ; i ++ )
{ _rtDW -> Buffer_CircBuf [ i ] = ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> P_5 ; } _rtDW -> Buffer_inBufPtrIdx = 256 ;
_rtDW -> Buffer_bufferLength = 256 ; _rtDW -> Buffer_outBufPtrIdx = 0 ; _rtDW
-> Window_FLAG = FALSE ; _rtDW -> DigitalFilter_CIRCBUFFIDX = 0 ; for ( i = 0
; i < 256 ; i ++ ) { _rtDW -> DigitalFilter_FILT_STATES [ i ] = 0.0 ; } }
void pll_wbsd_2_SpectrumScope ( SimStruct * const S ) { int32_T
offsetFromMemBase ; int32_T memIdx ; int32_T nSampsAtBot ; int32_T nSamps ;
int32_T i ; real_T accum ; int32_T idxN ; int32_T i_0 ; creal_T u ;
BlockIO_pll_wbsd_2 * _rtB ; Parameters_pll_wbsd_2 * _rtP ; D_Work_pll_wbsd_2
* _rtDW ; _rtDW = ( ( D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) ) ; _rtP = (
( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) ; _rtB = ( (
BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) ; if ( ssIsSampleHit ( S , 2 , 0
) ) { nSamps = 1 ; nSampsAtBot = 512 - _rtDW -> Buffer_inBufPtrIdx ;
offsetFromMemBase = _rtDW -> Buffer_inBufPtrIdx ; if ( nSampsAtBot <= 1 ) { i
= 0 ; while ( i < nSampsAtBot ) { _rtDW -> Buffer_CircBuf [ offsetFromMemBase
] = _rtB -> B_11_24_0 ; i = 1 ; } offsetFromMemBase = 0 ; nSamps = 1 -
nSampsAtBot ; } for ( i = 0 ; i < nSamps ; i ++ ) { _rtDW -> Buffer_CircBuf [
offsetFromMemBase + i ] = _rtB -> B_11_24_0 ; } _rtDW -> Buffer_inBufPtrIdx
++ ; if ( _rtDW -> Buffer_inBufPtrIdx >= 512 ) { _rtDW -> Buffer_inBufPtrIdx
-= 512 ; } _rtDW -> Buffer_bufferLength ++ ; if ( _rtDW ->
Buffer_bufferLength > 512 ) { _rtDW -> Buffer_outBufPtrIdx = ( _rtDW ->
Buffer_outBufPtrIdx + _rtDW -> Buffer_bufferLength ) - 512 ; if ( _rtDW ->
Buffer_outBufPtrIdx > 512 ) { _rtDW -> Buffer_outBufPtrIdx -= 512 ; } } } if
( ssIsSampleHit ( S , 3 , 0 ) ) { _rtDW -> Buffer_bufferLength -= 256 ; if (
_rtDW -> Buffer_bufferLength < 0 ) { _rtDW -> Buffer_outBufPtrIdx += _rtDW ->
Buffer_bufferLength ; if ( _rtDW -> Buffer_outBufPtrIdx < 0 ) { _rtDW ->
Buffer_outBufPtrIdx += 512 ; } _rtDW -> Buffer_bufferLength = 0 ; } i_0 = 0 ;
memIdx = _rtDW -> Buffer_outBufPtrIdx ; if ( memIdx < 0 ) { memIdx += 512 ; }
nSampsAtBot = 512 - memIdx ; nSamps = 256 ; if ( nSampsAtBot <= 256 ) { for (
i = 0 ; i < nSampsAtBot ; i ++ ) { _rtB -> B_10_0_0 [ i ] = _rtDW ->
Buffer_CircBuf [ memIdx + i ] ; } i_0 = nSampsAtBot ; memIdx = 0 ; nSamps =
256 - nSampsAtBot ; } for ( i = 0 ; i < nSamps ; i ++ ) { _rtB -> B_10_0_0 [
i_0 + i ] = _rtDW -> Buffer_CircBuf [ memIdx + i ] ; } memIdx += nSamps ;
_rtDW -> Buffer_outBufPtrIdx = memIdx ; memcpy ( & _rtB -> B_10_1_0 [ 0 ] , &
_rtB -> B_10_0_0 [ 0 ] , sizeof ( real_T ) << 8U ) ; offsetFromMemBase = 0 ;
i_0 = 0 ; for ( i = 0 ; i < 256 ; i ++ ) { _rtB -> B_10_2_0 [
offsetFromMemBase ] = _rtB -> B_10_1_0 [ offsetFromMemBase ] *
pll_wbsd_2_rtConstP . Window_WindowSamples [ i_0 ] ; offsetFromMemBase ++ ;
i_0 ++ ; } if ( ! _rtDW -> Window_FLAG ) { _rtDW -> Window_FLAG = TRUE ; i_0
= 0 ; for ( i = 0 ; i < 256 ; i ++ ) { _rtB -> B_10_2_1 [ i_0 ] =
pll_wbsd_2_rtConstP . Window_WindowSamples [ i_0 ] ; i_0 ++ ; } }
LibOutputs_FFT ( & _rtDW -> FFT_HostLib [ 0U ] , & _rtB -> B_10_2_0 [ 0U ] ,
& _rtB -> B_10_3_0 [ 0U ] , 256 , 1 ) ; for ( i = 0 ; i < 256 ; i ++ ) { u =
_rtB -> B_10_3_0 [ i ] ; accum = u . re * u . re + u . im * u . im ; _rtB ->
B_10_4_0 [ i ] = accum ; } offsetFromMemBase = 0 ; for ( i_0 = 0 ; i_0 < 256
; i_0 ++ ) { idxN = _rtDW -> DigitalFilter_CIRCBUFFIDX ; accum = _rtB ->
B_10_4_0 [ offsetFromMemBase ] * _rtP -> P_6 ; for ( memIdx = idxN ; memIdx <
0 ; memIdx ++ ) { accum += _rtDW -> DigitalFilter_FILT_STATES [ i_0 + memIdx
] * _rtP -> P_6 ; } for ( memIdx = 0 ; memIdx < idxN ; memIdx ++ ) { accum +=
_rtDW -> DigitalFilter_FILT_STATES [ i_0 + memIdx ] * _rtP -> P_6 ; } _rtDW
-> DigitalFilter_FILT_STATES [ i_0 + idxN ] = _rtB -> B_10_4_0 [
offsetFromMemBase ] ; _rtB -> B_10_5_0 [ offsetFromMemBase ] = accum ;
offsetFromMemBase ++ ; } _rtDW -> DigitalFilter_CIRCBUFFIDX = idxN ; accum =
_rtB -> B_10_2_1 [ 0 ] ; for ( nSampsAtBot = 0 ; nSampsAtBot < 255 ;
nSampsAtBot ++ ) { nSamps = nSampsAtBot + 1 ; accum += _rtB -> B_10_2_1 [
nSamps ] ; } _rtB -> B_10_6_0 = accum ; _rtB -> B_10_7_0 = _rtB -> B_10_6_0 *
_rtB -> B_10_6_0 ; _rtB -> B_10_8_0 = 1.0 / _rtB -> B_10_7_0 ; for ( i = 0 ;
i < 256 ; i ++ ) { _rtB -> B_10_9_0 [ i ] = _rtB -> B_10_5_0 [ i ] * _rtB ->
B_10_8_0 ; } } } void pll_wbsd_2_SpectrumScope_Update ( SimStruct * const S )
{ if ( ssIsSampleHit ( S , 3 , 0 ) ) { ssCallAccelRunBlock ( S , 10 , 10 ,
SS_CALL_MDL_UPDATE ) ; } } void pll_wbsd_2_SpectrumScope_Term ( SimStruct *
const S ) { char_T * sErr ; D_Work_pll_wbsd_2 * _rtDW ; _rtDW = ( (
D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) ) ; sErr = GetErrorBuffer ( &
_rtDW -> FFT_HostLib [ 0U ] ) ; LibTerminate ( & _rtDW -> FFT_HostLib [ 0U ]
) ; if ( * sErr != 0 ) { ssSetErrorStatus ( S , sErr ) ; ssSetStopRequested (
S , 1 ) ; } LibDestroy ( & _rtDW -> FFT_HostLib [ 0U ] , 0 ) ;
DestroyHostLibrary ( & _rtDW -> FFT_HostLib [ 0U ] ) ; ssCallAccelRunBlock (
S , 10 , 10 , SS_CALL_MDL_TERMINATE ) ; } uint32_T MWDSP_EPH_R_D ( real_T evt
, uint32_T * sta ) { uint32_T retVal ; int32_T curState ; int32_T newState ;
int32_T newStateR ; int32_T lastzcevent ; uint32_T previousState ;
previousState = * sta ; retVal = 0U ; lastzcevent = 0 ; newState = 5 ;
newStateR = 5 ; if ( evt > 0.0 ) { curState = 2 ; } else if ( evt < 0.0 ) {
curState = 0 ; } else { curState = 1 ; } if ( previousState == 5U ) {
newStateR = curState ; } else { if ( ( uint32_T ) curState != previousState )
{ if ( previousState == 3U ) { if ( ( uint32_T ) curState == 1U ) { newStateR
= 1 ; } else { lastzcevent = 2 ; previousState = 1U ; } } if ( previousState
== 4U ) { if ( ( uint32_T ) curState == 1U ) { newStateR = 1 ; } else {
lastzcevent = 3 ; previousState = 1U ; } } if ( ( previousState == 1U ) && (
( uint32_T ) curState == 2U ) ) { retVal = 2U ; } if ( previousState == 0U )
{ retVal = 2U ; } if ( retVal == ( uint32_T ) lastzcevent ) { retVal = 0U ; }
if ( ( uint32_T ) curState == 1U ) { if ( retVal == 2U ) { newState = 3 ; }
else { newState = 1 ; } } else { newState = curState ; } } } if ( ( uint32_T
) newStateR != 5U ) { * sta = ( uint32_T ) newStateR ; retVal = 0U ; } if ( (
uint32_T ) newState != 5U ) { * sta = ( uint32_T ) newState ; } return retVal
; } static void mdlOutputs ( SimStruct * S , int_T tid ) { BlockIO_pll_wbsd_2
* _rtB ; Parameters_pll_wbsd_2 * _rtP ; ContinuousStates_pll_wbsd_2 * _rtX ;
PrevZCSigStates_pll_wbsd_2 * _rtZCE ; D_Work_pll_wbsd_2 * _rtDW ; _rtDW = ( (
D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) ) ; _rtZCE = ( (
PrevZCSigStates_pll_wbsd_2 * ) _ssGetPrevZCSigState ( S ) ) ; _rtX = ( (
ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) ; _rtP = ( (
Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) ; _rtB = ( (
BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) ; if ( ssIsSampleHit ( S , 1 , 0
) ) { _rtB -> B_11_0_0 = _rtP -> P_7 ; _rtB -> B_11_1_0 = _rtP -> P_8 ; _rtB
-> B_11_2_0 = _rtDW -> TmpLatchAtFrequencyDividerInport1_PreviousInput ; }
_rtB -> B_11_3_0 = _rtP -> P_10 * _rtX -> Integrator_CSTATE ; if (
ssIsMajorTimeStep ( S ) ) { _rtDW -> Abs_MODE = _rtB -> B_11_3_0 >= 0.0 ? 1 :
0 ; } _rtB -> B_11_4_0 = _rtDW -> Abs_MODE > 0 ? _rtB -> B_11_3_0 : - _rtB ->
B_11_3_0 ; if ( ssIsSampleHit ( S , 1 , 0 ) ) { _rtB -> B_11_5_0 = _rtP ->
P_11 ; if ( ssIsMajorTimeStep ( S ) ) { _rtDW -> RelationalOperator_Mode = (
_rtB -> B_11_4_0 >= _rtB -> B_11_5_0 ) ; } _rtB -> B_11_6_0 = ( real_T )
_rtDW -> RelationalOperator_Mode ; } _rtB -> B_11_7_0 = muDoubleScalarRem (
_rtB -> B_11_3_0 , _rtB -> B_11_5_0 ) ; if ( ( _rtDW -> IC_FirstOutputTime ==
( rtMinusInf ) ) || ( _rtDW -> IC_FirstOutputTime == ssGetTaskTime ( S , 0 )
) ) { _rtDW -> IC_FirstOutputTime = ssGetTaskTime ( S , 0 ) ; _rtB ->
B_11_8_0 = _rtP -> P_12 ; } else { _rtB -> B_11_8_0 = _rtB -> B_11_7_0 ; } if
( ssIsMajorTimeStep ( S ) ) { ZCEventType zcEvent ; boolean_T resetIntg =
FALSE ; zcEvent = rt_ZCFcn ( RISING_ZERO_CROSSING , & ( (
PrevZCSigStates_pll_wbsd_2 * ) _ssGetPrevZCSigState ( S ) ) ->
Integrator_Reset_ZCE , ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) ->
B_11_6_0 ) ; if ( zcEvent || ( ( D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) )
-> Integrator_IWORK . IcNeedsLoading ) { resetIntg = TRUE ; ( (
ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) -> Integrator_CSTATE
= ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_11_8_0 ; } if (
resetIntg ) { ssSetSolverNeedsReset ( S ) ; ssSetBlkStateChange ( S ) ; } ( (
D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) ) -> Integrator_IWORK .
IcNeedsLoading = 0 ; } ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) ->
B_11_9_0 = ( ( ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) ->
Integrator_CSTATE ; ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) ->
B_11_10_0 = ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_11_9_0 ;
_rtB -> B_11_11_0 = muDoubleScalarCos ( _rtB -> B_11_10_0 *
6.2831853071795862 ) ; ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) ->
B_11_12_0 = ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_11_11_0 ;
if ( ssIsSampleHit ( S , 1 , 0 ) ) { _rtB -> B_11_13_0 = _rtP -> P_13 ; if (
ssIsMajorTimeStep ( S ) ) { _rtDW -> RelationalOperator_Mode_e = ( _rtB ->
B_11_12_0 > _rtB -> B_11_13_0 ) ; } _rtB -> B_11_14_0 = ( real_T ) _rtDW ->
RelationalOperator_Mode_e ; _rtB -> B_11_15_0 = _rtB -> B_11_14_0 ; if (
ssIsMajorTimeStep ( S ) && ( rt_ZCFcn ( RISING_ZERO_CROSSING , & _rtZCE ->
FrequencyDivider_Trig_ZCE , ( _rtB -> B_11_15_0 ) ) != NO_ZCEVENT ) ) { _rtB
-> B_2_0_0 = _rtP -> P_2 ; _rtB -> B_2_1_0 = _rtDW -> UnitDelay_DSTATE ; _rtB
-> B_2_2_0 = muDoubleScalarMod ( _rtB -> B_2_1_0 , _rtB -> B_11_2_0 ) ; _rtB
-> B_2_3_0 = ( real_T ) ( _rtB -> B_2_2_0 < 1.0 ) ; _rtB -> B_2_4_0 = _rtB ->
B_2_0_0 + _rtB -> B_2_2_0 ; _rtDW -> UnitDelay_DSTATE = _rtB -> B_2_4_0 ;
_rtDW -> FrequencyDivider_SubsysRanBC = 4 ; } _rtB -> B_11_17_0 = _rtB ->
B_2_3_0 ; if ( ssIsMajorTimeStep ( S ) && ( rt_ZCFcn ( RISING_ZERO_CROSSING ,
& _rtZCE -> MultiStageNoiseShaping_Trig_ZCE , ( _rtB -> B_11_17_0 ) ) !=
NO_ZCEVENT ) ) { pll_wbsd_2_Accumulator1 ( S , _rtB -> B_11_1_0 , & ( (
BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> Accumulator1 , & ( (
D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) ) -> Accumulator1 , (
rtP_Accumulator1_pll_wbsd_2 * ) & ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> Accumulator1 ) ; pll_wbsd_2_Accumulator1 ( S ,
_rtB -> Accumulator1 . B_4_1_0 , & ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO (
S ) ) -> Accumulator2 , & ( ( D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) ) ->
Accumulator2 , ( rtP_Accumulator1_pll_wbsd_2 * ) & ( ( Parameters_pll_wbsd_2
* ) ssGetDefaultParam ( S ) ) -> Accumulator2 ) ; _rtB -> B_6_2_0 = _rtDW ->
Delay1_IC_BUFF ; _rtB -> B_6_3_0 = _rtDW -> Delay3_IC_BUFF ; _rtB -> B_6_4_0
= _rtDW -> Delay5_IC_BUFF ; _rtB -> B_6_5_0 = _rtDW -> Delay7_IC_BUFF ; _rtB
-> B_6_6_0 = _rtB -> Accumulator2 . B_4_4_0 - _rtB -> B_6_2_0 ; _rtB ->
B_6_7_0 = _rtB -> B_6_6_0 + _rtB -> B_6_3_0 ; _rtB -> B_6_8_0 = _rtB ->
B_6_4_0 - _rtB -> B_6_7_0 ; _rtB -> B_6_9_0 = _rtB -> B_6_8_0 + _rtB ->
B_6_5_0 ; _rtB -> B_6_10_0 = _rtB -> B_6_5_0 + _rtB -> B_6_4_0 ;
pll_wbsd_2_Accumulator1_Update ( S , & ( ( BlockIO_pll_wbsd_2 * )
_ssGetBlockIO ( S ) ) -> Accumulator1 , & ( ( D_Work_pll_wbsd_2 * )
ssGetRootDWork ( S ) ) -> Accumulator1 ) ; pll_wbsd_2_Accumulator1_Update ( S
, & ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> Accumulator2 , & ( (
D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) ) -> Accumulator2 ) ; _rtDW ->
Delay1_IC_BUFF = _rtB -> Accumulator2 . B_4_4_0 ; _rtDW -> Delay3_IC_BUFF =
_rtB -> Accumulator1 . B_4_4_0 ; _rtDW -> Delay5_IC_BUFF = _rtB -> B_11_1_0 ;
_rtDW -> Delay7_IC_BUFF = _rtB -> B_6_9_0 ; _rtDW ->
MultiStageNoiseShaping_SubsysRanBC = 4 ; } _rtB -> B_11_19_0 = _rtB ->
B_11_0_0 + _rtB -> B_6_7_0 ; ssCallAccelRunBlock ( S , 11 , 20 ,
SS_CALL_MDL_OUTPUTS ) ; } _rtB -> B_11_21_0 = muDoubleScalarSin ( _rtP ->
P_16 * ssGetTaskTime ( S , 0 ) + _rtP -> P_17 ) * _rtP -> P_14 + _rtP -> P_15
; _rtB -> B_11_22_0 = _rtB -> B_11_21_0 * _rtB -> B_11_12_0 ; { { static
const int_T colCidxRow0 [ 8 ] = { 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 } ; const
int_T * pCidx = & colCidxRow0 [ 0 ] ; const real_T * pC0 = ( (
Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_20 ; const real_T *
xc = & ( ( ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) ->
antialias_CSTATE [ 0 ] ; real_T * y0 = & ( ( BlockIO_pll_wbsd_2 * )
_ssGetBlockIO ( S ) ) -> B_11_23_0 ; int_T numNonZero = 7 ; * y0 = ( * pC0 ++
) * xc [ * pCidx ++ ] ; while ( numNonZero -- ) { * y0 += ( * pC0 ++ ) * xc [
* pCidx ++ ] ; } } ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) ->
B_11_23_0 += ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_21
* ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_11_22_0 ; } if (
ssIsSampleHit ( S , 2 , 0 ) ) { _rtB -> B_11_24_0 = _rtB -> B_11_23_0 ; }
pll_wbsd_2_SpectrumScope ( S ) ; ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S
) ) -> B_11_26_0 = ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) ->
P_25 * ( ( ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) ->
Integrator_CSTATE_k ; _rtB -> B_11_27_0 = muDoubleScalarSin ( _rtP -> P_30 *
ssGetTaskTime ( S , 0 ) + _rtP -> P_31 ) * _rtP -> P_28 + _rtP -> P_29 ; if (
ssIsSampleHit ( S , 1 , 0 ) ) { _rtB -> B_11_28_0 = _rtP -> P_32 ; if (
ssIsMajorTimeStep ( S ) ) { _rtDW -> RelationalOperator_Mode_j = ( _rtB ->
B_11_27_0 > _rtB -> B_11_28_0 ) ; } _rtB -> B_11_29_0 = ( real_T ) _rtDW ->
RelationalOperator_Mode_j ; _rtB -> B_11_30_0 = _rtDW ->
TmpLatchAtDFlipFlopInport1_PreviousInput ; _rtB -> B_11_31_0 = _rtDW ->
Memory_PreviousInput ; _rtB -> B_11_32_0 = _rtB -> B_11_31_0 ; _rtB ->
B_11_33_0 = _rtB -> B_2_3_0 ; pll_wbsd_2_DFlipFlop ( S , _rtB -> B_11_32_0 ,
_rtB -> B_11_33_0 , _rtB -> B_11_30_0 , & ( ( BlockIO_pll_wbsd_2 * )
_ssGetBlockIO ( S ) ) -> DFlipFlop , & ( ( D_Work_pll_wbsd_2 * )
ssGetRootDWork ( S ) ) -> DFlipFlop , ( rtP_DFlipFlop_pll_wbsd_2 * ) & ( (
Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> DFlipFlop , & ( (
PrevZCSigStates_pll_wbsd_2 * ) _ssGetPrevZCSigState ( S ) ) -> DFlipFlop ) ;
_rtB -> B_11_35_0 = ( real_T ) ( ( _rtB -> B_11_29_0 != 0.0 ) || ( _rtB ->
DFlipFlop . B_7_0_0 != 0.0 ) ) ; _rtB -> B_11_36_0 = _rtB -> B_11_35_0 ; if (
ssIsMajorTimeStep ( S ) && ( rt_ZCFcn ( RISING_ZERO_CROSSING , & _rtZCE ->
SampleandHold_Trig_ZCE , ( _rtB -> B_11_36_0 ) ) != NO_ZCEVENT ) ) { _rtB ->
B_9_0_0 = _rtB -> B_11_26_0 ; _rtDW -> SampleandHold_SubsysRanBC = 4 ; } } (
( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_11_38_0 = ( ( (
Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_37 ) * ( (
ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) -> LoopFilter_CSTATE
; ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_11_38_0 += ( (
Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_38 * ( (
BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_9_0_0 ; _rtB -> B_11_39_0 =
_rtP -> P_40 * _rtB -> B_11_38_0 ; if ( ssIsSampleHit ( S , 1 , 0 ) ) { _rtB
-> B_11_40_0 = _rtP -> P_41 ; } _rtB -> B_11_41_0 = _rtB -> B_11_39_0 + _rtB
-> B_11_40_0 ; _rtB -> B_11_42_0 = _rtP -> P_42 * _rtB -> B_11_41_0 ;
ssCallAccelRunBlock ( S , 11 , 43 , SS_CALL_MDL_OUTPUTS ) ;
ssCallAccelRunBlock ( S , 11 , 44 , SS_CALL_MDL_OUTPUTS ) ; if (
ssIsSampleHit ( S , 1 , 0 ) ) { _rtB -> B_11_45_0 = _rtDW ->
TmpLatchAtDFFInport1_PreviousInput ; _rtB -> B_11_46_0 = 0.0 ; if (
MWDSP_EPH_R_D ( _rtB -> B_2_3_0 , & _rtDW -> Counter_RstEphState ) != 0U ) {
_rtDW -> Counter_Count = _rtP -> P_49 ; } if ( MWDSP_EPH_R_D ( _rtB ->
B_11_14_0 , & _rtDW -> Counter_ClkEphState ) != 0U ) { if ( _rtDW ->
Counter_Count < pll_wbsd_2_rtConstP . Counter_MaximumCount ) { _rtDW ->
Counter_Count = ( uint8_T ) ( ( uint32_T ) _rtDW -> Counter_Count + 1U ) ; }
else { _rtDW -> Counter_Count = 0U ; } } if ( _rtDW -> Counter_Count == _rtP
-> P_50 ) { _rtB -> B_11_46_0 = 1.0 ; } _rtB -> B_11_47_0 = ( real_T ) ( (
_rtB -> B_2_3_0 != 0.0 ) || ( _rtB -> B_11_46_0 != 0.0 ) ) ; _rtB ->
B_11_48_0 = _rtB -> B_11_47_0 ; if ( ssIsMajorTimeStep ( S ) && ( rt_ZCFcn (
RISING_ZERO_CROSSING , & _rtZCE -> DFF_Trig_ZCE , ( _rtB -> B_11_48_0 ) ) !=
NO_ZCEVENT ) ) { _rtB -> B_3_0_0 = _rtB -> B_11_45_0 ; _rtB -> B_3_1_0 = (
real_T ) ! ( _rtB -> B_3_0_0 != 0.0 ) ; _rtDW -> DFF_SubsysRanBC = 4 ; } if (
_rtB -> B_3_0_0 >= _rtP -> P_44 ) { _rtB -> B_1_0_0 = _rtP -> P_1 ; _rtB ->
B_11_52_0 = _rtB -> B_1_0_0 ; } else { _rtB -> B_0_0_0 = _rtP -> P_0 * _rtB
-> B_6_10_0 ; _rtB -> B_11_52_0 = _rtB -> B_0_0_0 ; } _rtB -> B_11_53_0 =
_rtP -> P_45 ; _rtB -> B_11_54_0 = _rtDW ->
TmpLatchAtDFlipFlopInport1_PreviousInput_a ; _rtB -> B_11_55_0 = _rtB ->
B_11_31_0 ; _rtB -> B_11_56_0 = _rtB -> B_11_29_0 ; pll_wbsd_2_DFlipFlop ( S
, _rtB -> B_11_55_0 , _rtB -> B_11_56_0 , _rtB -> B_11_54_0 , & ( (
BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> DFlipFlop_j , & ( (
D_Work_pll_wbsd_2 * ) ssGetRootDWork ( S ) ) -> DFlipFlop_j , (
rtP_DFlipFlop_pll_wbsd_2 * ) & ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> DFlipFlop_j , & ( ( PrevZCSigStates_pll_wbsd_2 *
) _ssGetPrevZCSigState ( S ) ) -> DFlipFlop_j ) ; _rtB -> B_11_58_0 = (
real_T ) ! ( ( _rtB -> DFlipFlop_j . B_7_0_0 != 0.0 ) && ( _rtB -> DFlipFlop
. B_7_0_0 != 0.0 ) ) ; _rtB -> B_11_59_0 = ( _rtB -> DFlipFlop_j . B_7_0_0 -
_rtB -> DFlipFlop . B_7_0_0 ) + _rtB -> B_11_52_0 ; _rtB -> B_11_60_0 = _rtP
-> P_47 ; } _rtB -> B_11_62_0 = _rtB -> B_11_38_0 ; _rtB -> B_11_63_0 = _rtP
-> P_48 * _rtB -> B_11_62_0 ; _rtB -> B_11_64_0 = _rtB -> B_11_63_0 + _rtB ->
B_11_60_0 ; UNUSED_PARAMETER ( tid ) ; }
#define MDL_UPDATE
static void mdlUpdate ( SimStruct * S , int_T tid ) { BlockIO_pll_wbsd_2 *
_rtB ; D_Work_pll_wbsd_2 * _rtDW ; _rtDW = ( ( D_Work_pll_wbsd_2 * )
ssGetRootDWork ( S ) ) ; _rtB = ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S
) ) ; if ( ssIsSampleHit ( S , 1 , 0 ) ) { _rtDW ->
TmpLatchAtFrequencyDividerInport1_PreviousInput = _rtB -> B_11_19_0 ; }
pll_wbsd_2_SpectrumScope_Update ( S ) ; if ( ssIsSampleHit ( S , 1 , 0 ) ) {
_rtDW -> TmpLatchAtDFlipFlopInport1_PreviousInput = _rtB -> B_11_53_0 ; _rtDW
-> Memory_PreviousInput = _rtB -> B_11_58_0 ; _rtDW ->
TmpLatchAtDFFInport1_PreviousInput = _rtB -> B_3_1_0 ; _rtDW ->
TmpLatchAtDFlipFlopInport1_PreviousInput_a = _rtB -> B_11_53_0 ; }
UNUSED_PARAMETER ( tid ) ; }
#define MDL_DERIVATIVES
static void mdlDerivatives ( SimStruct * S ) { BlockIO_pll_wbsd_2 * _rtB ;
_rtB = ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) ; { ( (
StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) ) -> Integrator_CSTATE = ( (
BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_11_64_0 ; } { ( (
StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) ) -> antialias_CSTATE [ 0 ] = (
( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_18 [ 0 ] ) * ( (
ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) -> antialias_CSTATE [
0 ] + ( ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_18 [ 1 ]
) * ( ( ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) ->
antialias_CSTATE [ 1 ] ; ( ( StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) )
-> antialias_CSTATE [ 0 ] += ( ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> P_19 [ 0 ] ) * ( ( BlockIO_pll_wbsd_2 * )
_ssGetBlockIO ( S ) ) -> B_11_22_0 ; ( ( StateDerivatives_pll_wbsd_2 * )
ssGetdX ( S ) ) -> antialias_CSTATE [ 1 ] = ( ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> P_18 [ 2 ] ) * ( ( ContinuousStates_pll_wbsd_2 *
) ssGetContStates ( S ) ) -> antialias_CSTATE [ 0 ] ; ( (
StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) ) -> antialias_CSTATE [ 2 ] = (
( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_18 [ 3 ] ) * ( (
ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) -> antialias_CSTATE [
0 ] + ( ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_18 [ 4 ]
) * ( ( ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) ->
antialias_CSTATE [ 1 ] + ( ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam (
S ) ) -> P_18 [ 5 ] ) * ( ( ContinuousStates_pll_wbsd_2 * ) ssGetContStates (
S ) ) -> antialias_CSTATE [ 2 ] + ( ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> P_18 [ 6 ] ) * ( ( ContinuousStates_pll_wbsd_2 *
) ssGetContStates ( S ) ) -> antialias_CSTATE [ 3 ] ; ( (
StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) ) -> antialias_CSTATE [ 2 ] +=
( ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_19 [ 1 ] ) * (
( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_11_22_0 ; ( (
StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) ) -> antialias_CSTATE [ 3 ] = (
( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_18 [ 7 ] ) * ( (
ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) -> antialias_CSTATE [
2 ] ; { static const int_T colAidxRow4 [ 6 ] = { 0 , 1 , 2 , 3 , 4 , 5 } ;
const int_T * pAidx = & colAidxRow4 [ 0 ] ; const real_T * pA8 = & ( (
Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) ) -> P_18 [ 8 ] ; const
real_T * xc = & ( ( ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) )
-> antialias_CSTATE [ 0 ] ; real_T * dx4 = & ( ( StateDerivatives_pll_wbsd_2
* ) ssGetdX ( S ) ) -> antialias_CSTATE [ 4 ] ; int_T numNonZero = 5 ; * dx4
= ( * pA8 ++ ) * xc [ * pAidx ++ ] ; while ( numNonZero -- ) { * dx4 += ( *
pA8 ++ ) * xc [ * pAidx ++ ] ; } } ( ( StateDerivatives_pll_wbsd_2 * )
ssGetdX ( S ) ) -> antialias_CSTATE [ 4 ] += ( ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> P_19 [ 2 ] ) * ( ( BlockIO_pll_wbsd_2 * )
_ssGetBlockIO ( S ) ) -> B_11_22_0 ; ( ( StateDerivatives_pll_wbsd_2 * )
ssGetdX ( S ) ) -> antialias_CSTATE [ 5 ] = ( ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> P_18 [ 14 ] ) * ( ( ContinuousStates_pll_wbsd_2
* ) ssGetContStates ( S ) ) -> antialias_CSTATE [ 4 ] ; { static const int_T
colAidxRow6 [ 8 ] = { 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 } ; const int_T * pAidx =
& colAidxRow6 [ 0 ] ; const real_T * pA15 = & ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> P_18 [ 15 ] ; const real_T * xc = & ( (
ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) ) -> antialias_CSTATE [
0 ] ; real_T * dx6 = & ( ( StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) ) ->
antialias_CSTATE [ 6 ] ; int_T numNonZero = 7 ; * dx6 = ( * pA15 ++ ) * xc [
* pAidx ++ ] ; while ( numNonZero -- ) { * dx6 += ( * pA15 ++ ) * xc [ *
pAidx ++ ] ; } } ( ( StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) ) ->
antialias_CSTATE [ 6 ] += ( ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam (
S ) ) -> P_19 [ 3 ] ) * ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) ->
B_11_22_0 ; ( ( StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) ) ->
antialias_CSTATE [ 7 ] = ( ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam (
S ) ) -> P_18 [ 23 ] ) * ( ( ContinuousStates_pll_wbsd_2 * ) ssGetContStates
( S ) ) -> antialias_CSTATE [ 6 ] ; } { ( ( StateDerivatives_pll_wbsd_2 * )
ssGetdX ( S ) ) -> Integrator_CSTATE_k = ( ( Parameters_pll_wbsd_2 * )
ssGetDefaultParam ( S ) ) -> P_24 * ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO
( S ) ) -> B_11_59_0 ; } { ( ( StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S )
) -> LoopFilter_CSTATE = ( ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam (
S ) ) -> P_35 ) * ( ( ContinuousStates_pll_wbsd_2 * ) ssGetContStates ( S ) )
-> LoopFilter_CSTATE ; ( ( StateDerivatives_pll_wbsd_2 * ) ssGetdX ( S ) ) ->
LoopFilter_CSTATE += ( ( Parameters_pll_wbsd_2 * ) ssGetDefaultParam ( S ) )
-> P_36 * ( ( BlockIO_pll_wbsd_2 * ) _ssGetBlockIO ( S ) ) -> B_9_0_0 ; } }
#define MDL_ZERO_CROSSINGS
static void mdlZeroCrossings ( SimStruct * S ) { BlockIO_pll_wbsd_2 * _rtB ;
ZCSignalValues_pll_wbsd_2 * _rtZCSV ; _rtZCSV = ( ( ZCSignalValues_pll_wbsd_2
* ) ssGetSolverZcSignalVector ( S ) ) ; _rtB = ( ( BlockIO_pll_wbsd_2 * )
_ssGetBlockIO ( S ) ) ; _rtZCSV -> Abs_AbsZc_ZC = _rtB -> B_11_3_0 ; _rtZCSV
-> RelationalOperator_RelopInput_ZC = _rtB -> B_11_4_0 - _rtB -> B_11_5_0 ;
_rtZCSV -> RelationalOperator_RelopInput_ZC_b = _rtB -> B_11_12_0 - _rtB ->
B_11_13_0 ; _rtZCSV -> RelationalOperator_RelopInput_ZC_b0 = _rtB ->
B_11_27_0 - _rtB -> B_11_28_0 ; } static void mdlInitializeSizes ( SimStruct
* S ) { ssSetChecksumVal ( S , 0 , 2047016069U ) ; ssSetChecksumVal ( S , 1 ,
2133479929U ) ; ssSetChecksumVal ( S , 2 , 3339257516U ) ; ssSetChecksumVal (
S , 3 , 3392378893U ) ; { mxArray * slVerStructMat = NULL ; mxArray *
slStrMat = mxCreateString ( "simulink" ) ; char slVerChar [ 10 ] ; int status
= mexCallMATLAB ( 1 , & slVerStructMat , 1 , & slStrMat , "ver" ) ; if (
status == 0 ) { mxArray * slVerMat = mxGetField ( slVerStructMat , 0 ,
"Version" ) ; if ( slVerMat == NULL ) { status = 1 ; } else { status =
mxGetString ( slVerMat , slVerChar , 10 ) ; } } mxDestroyArray ( slStrMat ) ;
mxDestroyArray ( slVerStructMat ) ; if ( ( status == 1 ) || ( strcmp (
slVerChar , "7.9" ) != 0 ) ) { return ; } } ssSetOptions ( S ,
SS_OPTION_EXCEPTION_FREE_CODE ) ; if ( ssGetSizeofDWork ( S ) != sizeof (
D_Work_pll_wbsd_2 ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal DWork sizes do "
"not match for accelerator mex file." ) ; } if ( ssGetSizeofGlobalBlockIO ( S
) != sizeof ( BlockIO_pll_wbsd_2 ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal BlockIO sizes do "
"not match for accelerator mex file." ) ; } { int ssSizeofParams ;
ssGetSizeofParams ( S , & ssSizeofParams ) ; if ( ssSizeofParams != sizeof (
Parameters_pll_wbsd_2 ) ) { static char msg [ 256 ] ; sprintf ( msg ,
"Unexpected error: Internal Parameters sizes do "
"not match for accelerator mex file." ) ; } } _ssSetDefaultParam ( S , (
real_T * ) & pll_wbsd_2_rtDefaultParameters ) ; rt_InitInfAndNaN ( sizeof (
real_T ) ) ; } static void mdlInitializeSampleTimes ( SimStruct * S ) { }
static void mdlTerminate ( SimStruct * S ) { }
#include "simulink.c"
