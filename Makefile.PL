use ExtUtils::MakeMaker;
use Config;

my @extras = ();
push(@extras, CAPI => 'TRUE')
    if (($PERL_VERSION >= 5.005) and ($OSNAME eq 'MSWin32')
        and ($Config{archname} =~ /-object\b/i));

push(@extras,
    ABSTRACT => "XS interface to bob jenkins perfect hash",
    AUTHOR   => 'Reini Urban')
  if ($ExtUtils::MakeMaker::VERSION >= 5.4301);

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

