ifndef TARGET
TARGET = native
endif

CONTIKI_PROJECT = contact-tracer
all: $(CONTIKI_PROJECT)

CONTIKI = ../contiki-ng
MAKE_NET = MAKE_NET_IPV6

include $(CONTIKI)/Makefile.dir-variables
MODULES += $(CONTIKI_NG_APP_LAYER_DIR)/http-socket

include $(CONTIKI)/Makefile.include
