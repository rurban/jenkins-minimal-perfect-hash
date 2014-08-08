use ExtUtils::MakeMaker;
use Config;

my @extras = ();
my $EUMM_VER = $ExtUtils::MakeMaker::VERSION;
push(@extras, CAPI => 'TRUE')
  if (($PERL_VERSION >= 5.005) and ($OSNAME eq 'MSWin32')
      and ($Config{archname} =~ /-object\b/i));

push(@extras,
     ABSTRACT => "XS interface to bob jenkins perfect hash",
     AUTHOR   => 'Reini Urban <rurban@cpan.org>')
  if $EUMM_VER gt '5.4301';
push(@extras,
     LICENSE      => 'perl_5'), #bob itself is in public domain
  if $EUMM_VER gt '6.17';

#TODO: integrate into proper build and depend rules
if (! -e "bin/perfect") {
  system($Config{'make'}, '-f', "Makefile.orig");
}

WriteMakefile(
  NAME         => 'Perfect::Hash::Bob',
  XS           => { 'Bob.xs' => 'Bob.c' },
  INC          => '-I.',
  LIBS         => '-lm',
  XSPROTOARG   => '-noprototypes',
  VERSION_FROM => '../lib/Perfect/Hash/Bob.pm',
  clean => { FILES => "Bob.gcno" },
  @extras
);

