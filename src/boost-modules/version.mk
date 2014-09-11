ifndef ROLLCOMPILER
  COMPILERNAME = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

NAME       = boost-modules_$(COMPILERNAME)
VERSION    = 1.55.0
RELEASE    = 0

RPM.EXTRAS = "AutoReq: no"
