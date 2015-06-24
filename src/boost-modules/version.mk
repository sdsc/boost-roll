ifndef ROLLCOMPILER
  COMPILERNAME = gnu
endif
ifndef ROLLMPI
  MPINAME = rocks-openmpi
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

PACKAGE     = boost
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules_$(COMPILERNAME)_$(MPINAME)
RELEASE     = 4
PKGROOT     = /opt/modulefiles/$(CATEGORY)/.$(COMPILERNAME)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
