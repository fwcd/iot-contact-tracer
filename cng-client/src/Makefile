ifndef TARGET
TARGET = sky
endif

CONTIKI_PROJECT = contact-tracer
all: $(CONTIKI_PROJECT)

CONTIKI = ../contiki-ng
MAKE_MAC ?= MAKE_MAC_CSMA
MAKE_NET = MAKE_NET_NULLNET

include $(CONTIKI)/Makefile.dir-variables

include $(CONTIKI)/Makefile.include
