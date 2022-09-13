// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  hsG_0__0 (struct dummyq_struct * I1297, EBLK  * I1292, U  I689);
void  hsG_0__0 (struct dummyq_struct * I1297, EBLK  * I1292, U  I689)
{
    U  I1558;
    U  I1559;
    U  I1560;
    struct futq * I1561;
    struct dummyq_struct * pQ = I1297;
    I1558 = ((U )vcs_clocks) + I689;
    I1560 = I1558 & ((1 << fHashTableSize) - 1);
    I1292->I734 = (EBLK  *)(-1);
    I1292->I735 = I1558;
    if (I1558 < (U )vcs_clocks) {
        I1559 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1292, I1559 + 1, I1558);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I689 == 1)) {
        I1292->I737 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I734 = I1292;
        peblkFutQ1Tail = I1292;
    }
    else if ((I1561 = pQ->I1202[I1560].I749)) {
        I1292->I737 = (struct eblk *)I1561->I748;
        I1561->I748->I734 = (RP )I1292;
        I1561->I748 = (RmaEblk  *)I1292;
    }
    else {
        sched_hsopt(pQ, I1292, I1558);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
