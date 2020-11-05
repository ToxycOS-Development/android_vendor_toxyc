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

PRODUCT_BRAND ?= ToxycOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/toxyc/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/toxyc/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/toxyc/prebuilt/common/bin/50-toxyc.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-toxyc.sh

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/toxyc/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/toxyc/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/toxyc/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/toxyc/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# Copy all Toxyc-specific init rc files
$(foreach f,$(wildcard vendor/toxyc/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/toxyc/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/toxyc/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Blur
ifeq ($(TARGET_USES_BLUR), true)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
endif

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Device Overlays
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/toxyc/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/toxyc/overlay/common

#Telephony
$(call inherit-product, vendor/toxyc/config/telephony.mk)

# Packages
include vendor/toxyc/config/packages.mk

# Our Branding!
include vendor/toxyc/config/branding.mk

# Bootanimation
include vendor/toxyc/bootanimation/bootanimation.mk

# ToxycOS_props
$(call inherit-product, vendor/toxyc/config/toxyc_props.mk)

# Poison
include vendor/poison/poison.mk
