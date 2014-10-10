ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

NAME           = boost_$(COMPILERNAME)
VERSION        = 1.56.0
RELEASE        = 0
PKGROOT        = /opt/boost/$(COMPILERNAME)

SRC_SUBDIR     = boost

SOURCE_NAME    = boost
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = 1_56_0
SOURCE_PKG     = $(SOURCE_NAME)_$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
