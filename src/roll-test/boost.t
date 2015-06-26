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
my @MPIS = split(/\s+/, 'ROLLMPI');

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
module load \$1 \$3 boost
\$2 -I /opt/boost/\$1/\$3/include -o $TESTFILE.exe $TESTFILE.cxx
./$TESTFILE.exe
END
close(OUT);

# boost-common.xml
foreach my $compiler (@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    if($appliance =~ /$installedOnAppliancesPattern/) {
      ok(-e "/opt/boost/$compilername/$mpi", "boost $compiler installed");
    } else {
      ok(! -e "/opt/boost/$compilername/$mpi", "boost $compiler not installed");
    }
  }
}

foreach my $compiler (@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
     skip "boost/$compilername/$mpi not installed", 2
     if ! -e "/opt/boost/$compilername/$mpi";
     `/bin/rm -f $TESTFILE.exe`;
     $output = `/bin/bash $TESTFILE.sh $compilername $CPLUSPLUS{$compilername} $mpi 2>&1`;
     ok(-e "$TESTFILE.exe", "boost/$compiler/$mpi compilation");
     like($output, qr/0,1,2/, "boost/$compiler/$mpi run");
  }
}

SKIP: {

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
