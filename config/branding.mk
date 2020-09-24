# Copyright (C) 2018-20 Project ToxycOS
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
TOXYC_MOD_VERSION = v4.0


ifndef TOXYC_BUILD_TYPE
    TOXYC_BUILD_TYPE := UNOFFICIAL
endif

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
TOXYC_DATE_YEAR := $(shell date -u +%Y)
TOXYC_DATE_MONTH := $(shell date -u +%m)
TOXYC_DATE_DAY := $(shell date -u +%d)
TOXYC_DATE_HOUR := $(shell date -u +%H)
TOXYC_DATE_MINUTE := $(shell date -u +%M)
TOXYC_BUILD_DATE_UTC := $(shell date -d '$(TOXYC_DATE_YEAR)-$(TOXYC_DATE_MONTH)-$(TOXYC_DATE_DAY) $(TOXYC_DATE_HOUR):$(TOXYC_DATE_MINUTE) UTC' +%s)
CUSTOM_BUILD_DATE := $(TOXYC_DATE_YEAR)$(TOXYC_DATE_MONTH)$(TOXYC_DATE_DAY)-$(TOXYC_DATE_HOUR)$(TOXYC_DATE_MINUTE)

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

TOXYC_VERSION := ToxycOS-$(TOXYC_MOD_VERSION)-$(CURRENT_DEVICE)-$(TOXYC_BUILD_TYPE)-$(CUSTOM_BUILD_DATE)

TOXYC_FINGERPRINT := ToxycOS/$(TOXYC_MOD_VERSION)/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(CUSTOM_BUILD_DATE)

TOXYC_DISPLAY_VERSION := ToxycOS-$(TOXYC_MOD_VERSION)-$(TOXYC_BUILD_TYPE)

PRODUCT_GENERIC_PROPERTIES += \
  ro.toxyc.version=$(TOXYC_VERSION) \
  ro.toxyc.releasetype=$(TOXYC_BUILD_TYPE) \
  ro.modversion=$(TOXYC_MOD_VERSION) \
  ro.toxyc.display.version=$(TOXYC_DISPLAY_VERSION)\
  ro.toxyc.fingerprint=$(TOXYC_FINGERPRINT)
