ifndef ROLLCOMPILER
  COMPILERNAME = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

NAME        = boost-modules_$(COMPILERNAME)
RELEASE     = 1
PKGROOT     = /opt/modulefiles/applications/.$(COMPILERNAME)/boost

VERSION_SRC = $(REDHAT.ROOT)/src/boost/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
