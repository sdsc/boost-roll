#!/usr/bin/perl -w
# boost roll installation test.  Usage:
# boost.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $isInstalled = -d '/opt/boost';
my $output;

my $TESTFILE = 'rollboost';

my @COMPILERS = split(/\s+/, 'ROLLCOMPILER');

# boost-common.xml
foreach my $compiler (@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  if($appliance =~ /$installedOnAppliancesPattern/) {
    ok(-e "/opt/boost/$compilername", "boost $compiler installed");
  } else {
    ok(! -e "/opt/boost/$compilername", "boost $compiler not installed");
  }
}

# TODO: test whether installed boost works

SKIP: {

  skip 'modules not installed', $#COMPILERS if ! -f '/etc/profile.d/modules.sh';
  skip 'boost not installed', $#COMPILERS if ! $isInstalled;
  foreach my $compiler (@COMPILERS) {
    my $compilername = (split('/', $compiler))[0];
    `/bin/ls /opt/modulefiles/applications/.$compilername/boost/[0-9]* 2>&1`;
    ok($? == 0, "boost $compiler module installed");
    `/bin/ls /opt/modulefiles/applications/.$compilername/boost/.version.[0-9]* 2>&1`;
    ok($? == 0, "boost $compiler version module installed");
    ok(-l "/opt/modulefiles/applications/.$compilername/boost/.version",
       "boost $compiler version module link created");
  }

}

`rm -fr $TESTFILE*`;
