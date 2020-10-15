# Copyright (C) 2020 Project ToxycOS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Branding!
TOXYC_MOD_VERSION = 4.0.0
TOXYC_VERSION_CODENAME  = Injected

ifndef TOXYC_BUILD_TYPE
    TOXYC_BUILD_TYPE := UNOFFICIAL
endif

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
BUILD_DATE := $(shell date +%Y%m%d)
BUILD_TIME := $(shell date +%H%M)

ifeq ($(TOXYC_OFFICIAL), true)
   LIST = $(shell cat vendor/toxyc/toxyc.devices)
   FOUND_DEVICE =  $(filter $(CURRENT_DEVICE), $(LIST))
    ifeq ($(FOUND_DEVICE),$(CURRENT_DEVICE))
      IS_OFFICIAL=true
      TOXYC_BUILD_TYPE := OFFICIAL

    endif
    ifneq ($(IS_OFFICIAL), true)
       TOXYC_BUILD_TYPE := UNOFFICIAL
       $(error Device is not official "$(FOUND)")
    endif

endif

TARGET_PRODUCT_SHORT := $(subst toxyc_,,$(TOXYC_BUILD))

TOXYC_VERSION := ToxycOS-$(TOXYC_MOD_VERSION)-$(TOXYC_VERSION_CODENAME)-$(CURRENT_DEVICE)-$(TOXYC_BUILD_TYPE)-$(BUILD_DATE)-$(BUILD_TIME)

TOXYC_FINGERPRINT := ToxycOS/$(TOXYC_MOD_VERSION)/$(TOXYC_VERSION_CODENAME)/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(BUILD_DATE)/$(BUILD_TIME)

TOXYC_DISPLAY_VERSION := $(TOXYC_MOD_VERSION)|$(TOXYC_VERSION_CODENAME)|$(TOXYC_BUILD_TYPE)

PRODUCT_GENERIC_PROPERTIES += \
  ro.toxyc.version=$(TOXYC_VERSION) \
  ro.toxyc.releasetype=$(TOXYC_BUILD_TYPE) \
  ro.modversion=$(TOXYC_MOD_VERSION) \
  ro.toxyc.display.version=$(TOXYC_DISPLAY_VERSION)\
  ro.toxyc.fingerprint=$(TOXYC_FINGERPRINT)
