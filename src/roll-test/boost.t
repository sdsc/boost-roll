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

my @COMPILERS = split(/\s+/, 'ROLLCOMPILER');
my %CPLUSPLUS = ('gnu' => 'g++', 'intel' => 'icpc', 'pgi' => 'pgCC');

my $TESTFILE = 'tmpboost';

# Adapted from http://programmingexamples.net/wiki/CPP/Boost/Numeric/Matrix
open(OUT, ">$TESTFILE.cxx");
print OUT <<END;
#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/io.hpp>
 
int main () {
  using namespace boost::numeric::ublas;
  matrix<double> m (3, 3);
  for (unsigned i = 0; i < m.size1 (); ++ i) {
    for (unsigned j = 0; j < m.size2 (); ++ j) {
      m (i, j) = 3 * i + j;
    }
  }
  std::cout << m << std::endl;
  return 0;
}
END
close(OUT);

open(OUT, ">$TESTFILE.sh");
print OUT <<END;
#!/bin/bash
if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
  module load \$1 boost
fi
\$2 -I /opt/boost/\$1/include -o $TESTFILE.exe $TESTFILE.cxx
./$TESTFILE.exe
END
close(OUT);

# boost-common.xml
foreach my $compiler (@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  if($appliance =~ /$installedOnAppliancesPattern/) {
    ok(-e "/opt/boost/$compilername", "boost $compiler installed");
  } else {
    ok(! -e "/opt/boost/$compilername", "boost $compiler not installed");
  }
}

foreach my $compiler (@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  skip "boost/$compilername not installed", 2
    if ! -e "/opt/boost/$compilername";
  `/bin/rm -f $TESTFILE.exe`;
  $output = `/bin/bash $TESTFILE.sh $compilername $CPLUSPLUS{$compilername} 2>&1`;
  ok(-e "$TESTFILE.exe", "boost/$compiler compilation");
  like($output, qr/0,1,2/, "boost/$compiler run");
}

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
