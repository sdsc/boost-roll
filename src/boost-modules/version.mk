ifndef ROLLCOMPILER
  COMPILERNAME = gnu
fi
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

NAME    	:= boost-modules_$(COMPILERNAME)
VERSION 	= 1.54.0
RELEASE 	= 0
RPM.EXTRAS = "AutoReq: no"
