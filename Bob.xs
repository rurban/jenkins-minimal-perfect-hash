/* -*- mode:C tab-width:4 -*- */
#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifdef USE_PPPORT_H
#  define NEED_sv_2pvbyte
#  define NEED_sv_2pv_nolen
#  define NEED_sv_pvn_force_flags
#  include "ppport.h"
#endif

#include "lookupa.h"
#include "lookupa.c"
#include "perfect.c"
#define __PACKAGE__ "Perfect::Hash::Bob"

MODULE = Perfect::Hash::Bob	PACKAGE = Perfect::Hash::Bob

SV*
new(class, dict, ...)
  SV*  class
  SV*  dict
CODE:
  AV *result;
  SV *ref;
  hashform pform;
  uint32_t nkeys;                                          /* number of keys */
  key      *keys;                                    /* head of list of keys */
  bstuff   *tab;                                       /* table indexed by b */
  uint32_t smax;             /* scramble[] values in 0..smax-1, a power of 2 */
  uint32_t alen;                             /* a in 0..alen-1, a power of 2 */
  uint32_t blen;                             /* b in 0..blen-1, a power of 2 */
  uint32_t salt;                         /* a parameter to the hash function */
  reroot   *textroot;                      /* MAXKEYLEN-character text lines */
  reroot   *keyroot;                                       /* source of keys */
  gencode  final;                                     /* code for final hash */
  uint32_t scramble[SCRAMBLE_LEN];            /* used in final hash function */
  /* default behavior */
  pform.mode = NORMAL_HM;
  pform.hashtype = STRING_HT;
  pform.perfect = MINIMAL_HP;
  pform.speed = SLOW_HS;
  pform.low_name = "perf";
  pform.high_name = "PERF";
  /* get keys */
  /* ... */
  /* Generate the [minimal] perfect hash */
  findhash(&tab, &alen, &blen, &salt, &final, 
           scramble, &smax, keys, nkeys, pform);
  /* ... */
  result = newAV();
  av_push(result, &PL_sv_undef);
  av_push(result, &PL_sv_undef);
  ref = newRV_noinc((SV*)result);
  RETVAL = sv_bless(ref, gv_stashpv(__PACKAGE__, 1));
OUTPUT:
  RETVAL

IV
perfecthash(ph, key)
    SV*  ph
    SV*  key
CODE:
    RETVAL = -1;
OUTPUT:
    RETVAL
