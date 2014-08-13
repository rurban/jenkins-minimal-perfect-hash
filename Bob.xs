/* -*- mode:C tab-width:4 -*- */
#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#if PERL_VERSION < 10
#  define USE_PPPORT_H
#  undef apply
#endif

#ifdef USE_PPPORT_H
#  define NEED_newRV_noinc
#  include "../ppport.h"
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
  AV *result, *xshash;
  HV *options;
  int i;
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
  /* default options */
  pform.mode = NORMAL_HM;
  pform.hashtype = STRING_HT;
  pform.perfect = MINIMAL_HP;
  pform.speed = SLOW_HS;
  pform.low_name = "perf";
  pform.high_name = "PERF";
  /* override options */
  /* ... */
  /* get keys */
  /* ... */
  /* Generate the [minimal] perfect hash */
  findhash(&tab, &alen, &blen, &salt, &final, 
           scramble, &smax, keys, nkeys, &pform);
  /* Do we really need to store all this? no struct?
     _ bstuff **tab, uint32_t *alen, uint32_t *blen, uint32_t *salt,
     gencode *final, uint32_t *scramble, uint32_t smax, key *keys, uint32_t nkeys,
	 hashform *form */
  xshash = newAV();
  av_push(xshash, newSViv(PTR2IV(tab)));
  av_push(xshash, newSViv(alen));
  av_push(xshash, newSViv(blen));
  av_push(xshash, newSViv(salt));
  av_push(xshash, newSViv(PTR2IV(&final))); /* XXX really on the stack? */
  av_push(xshash, newSViv(PTR2IV(scramble)));
  av_push(xshash, newSViv(smax));
  av_push(xshash, newSViv(PTR2IV(keys)));
  av_push(xshash, newSViv(nkeys));
  av_push(xshash, newSViv(PTR2IV(&pform))); /* XXX really on the stack? */
  result = newAV();
  av_push(result, newRV((SV*)xshash));
  options = newHV();
  for (i=2; i<items; i++) { /* CHECKME */
    hv_store_ent(options, ST(i), newSViv(1), 0);
  }
  av_push(result, newRV((SV*)options));
  RETVAL = sv_bless(newRV_noinc((SV*)result), gv_stashpv(__PACKAGE__, GV_ADDWARN));
OUTPUT:
  RETVAL

IV
perfecthash(ph, key)
    SV*  ph
    SV*  key
CODE:
  /* NYI */
  RETVAL = -1;
OUTPUT:
  RETVAL

void
save_c(ph, fileprefix)
    SV*    ph
    char*  fileprefix
CODE:
  /* better do that in C, not in perl */
