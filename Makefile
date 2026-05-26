ARCHS = arm64
TARGET = iphone:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = grnbypass
grnbypass_FILES = Tweak.xm
grnbypass_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk