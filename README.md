# SDSC "boost" roll

## Overview

This roll bundles the boost C++ libraries.

For more information about boost please visit <a href="http://www.boost.org">the
official web page</a>:

## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate boost source file(s) using a machine that does
have Internet access and copy them into the `src/<package>` directories on your
Rocks development machine.


## Dependencies

None.


## Building

To build the boost-roll, execute this on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make 2>&1 | tee build.log
```

A successful build will create the file `boost-*.disk1.iso`.  If you built the
roll on a Rocks frontend, proceed to the installation step. If you built the
roll on a Rocks development appliance, you need to copy the roll to your Rocks
frontend before continuing with installation.

This roll source supports building with different compilers; by default, it
builds using the gnu compilers.  To build for a different configuration, use
the `ROLLCOMPILER` make variable, e.g.,

```shell
% make ROLLCOMPILER=intel
```

The build process currently supports one or more of the values "intel", "pgi",
and "gnu" for the `ROLLCOMPILER` variable, defaulting to "gnu".


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll boost
% cd /export/rocks/install
% rocks create distro
% rocks run roll boost | bash
```

In addition to the software itself, the roll installs boost environment
module files in:

```shell
/opt/modulefiles/applications/.$(ROLLCOMPILER)/boost
```


## Testing

The boost-roll includes a test script which can be run to verify proper
installation of the roll binaries and module files. To run the test
scripts execute the following command(s):

```shell
% /root/rolltests/boost.t 
```
