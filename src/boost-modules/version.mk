ifndef ROLLCOMPILER
  COMPILERNAME = gnu
else
  COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))
endif

NAME    	:= boost-modules_$(COMPILERNAME)
VERSION 	= 1.54.0
RELEASE 	= 0
RPM.EXTRAS = "AutoReq: no"
