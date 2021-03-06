ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-boost_$(COMPILERNAME)_$(MPINAME)
VERSION        = 1.68.0
RELEASE        = 1
PKGROOT        = /opt/boost/$(COMPILERNAME)/$(MPINAME)

SRC_SUBDIR     = boost

SOURCE_NAME    = boost
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = 1_68_0
SOURCE_PKG     = $(SOURCE_NAME)_$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = "AutoProv:No\\nAutoReq:No\\n%define __os_install_post /usr/lib/rpm/brp-compress"
RPM.PREFIX     = $(PKGROOT)
