/* Include files */

#include "PraktikumSDR_cgxe.h"
#include "m_87bTlieNQt9lKFrZ3cTxCH.h"

unsigned int cgxe_PraktikumSDR_method_dispatcher(SimStruct* S, int_T method,
  void* data)
{
  if (ssGetChecksum0(S) == 3599961414 &&
      ssGetChecksum1(S) == 1232860519 &&
      ssGetChecksum2(S) == 1092433255 &&
      ssGetChecksum3(S) == 2651597155) {
    method_dispatcher_87bTlieNQt9lKFrZ3cTxCH(S, method, data);
    return 1;
  }

  return 0;
}
