#!/bin/bash

# cloning device trees for havoc
echo cloning device trees
git clone https://github.com/my-cp-stuff/device_xiaomi_miatoll device/xiaomi/miatoll && git clone https://github.com/my-cp-stuff/android_device_xiaomi_sm6250-common device/xiaomi/sm6250-common && git clone https://github.com/my-cp-stuff/vendor_xiaomi_sm6250-common vendor/xiaomi/sm6250-common && git clone https://github.com/Havoc-Devices/android_vendor_xiaomi_miatoll vendor/xiaomi/miatoll
echo cloning done for device tree

# clonning clang
echo cloning clang
git clone https://github.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-r416183b1 prebuilts/clang/host/linux-x86/clang-r416183b1
echo cloning done for clang

# saving ccache
echo Hmm time saving ccache
export USE_CCACHE=1
export CCACHE_EXEC=$(command -v ccache)
ccache -M 50G

# its build time
echo Very well its build time
. build/envsetup.sh
lunch derp_mido-user
time mka derp

# upload to gdrive
echo uploading build to Google drive
gdrive upload -p 1mUHZrbIW6rz2OWYqkJMawZ2ukmRJnDRj ./out/target/product/miatoll/Derp*.zip
echo build uploaded to team drive now dont be fucking lazy go to grive and get download link
