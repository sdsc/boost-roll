ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
fi
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

NAME    := boost_$(COMPILERNAME)
VERSION = 1.54.0
RELEASE = 2
RPM.EXTRAS = "AutoReq: no"

SRC_SUBDIR	= boost

BOOST_NAME	= boost
BOOST_VERSION	= $(VERSION)
BOOST_SOURCE	= $(BOOST_NAME)-$(BOOST_VERSION).tar.gz

TAR_GZ_PKGS	= $(BOOST_SOURCE)

