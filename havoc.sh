#!/bin/bash

# cloning device trees for havoc
echo cloning device trees
git clone https://github.com/Erickeagle3/device_xiaomi_mido -b havoc device/xiaomi/mido && git clone https://github.com/Erickeagle3/vendor_xiaomi.git vendor/xiaomi && git clone https://github.com/my-cp-stuff/kernel_xiaomi_msm8953-4.9.git kernel/xiaomi/mido
echo cloning done for device tree

# cloning hals for havoc
echo claning hals
rm -rf hardware/qcom-caf/msm8996/display hardware/qcom-caf/msm8996/audio hardware/qcom-caf/msm8996/media && git clone https://github.com/crdroidandroid/android_hardware_qcom_display.git -b 11.0-caf-msm8996 hardware/qcom-caf/msm8996/display && git clone https://github.com/crdroidandroid/android_hardware_qcom_audio -b 11.0-caf-msm8996 hardware/qcom-caf/msm8996/audio && git clone https://github.com/crdroidandroid/android_hardware_qcom_media.git -b 11.0-caf-msm8996 hardware/qcom-caf/msm8996/media
echo claning done for hals

# clonning clang
echo cloning clang
git clone https://github.com/ThankYouMario/proprietary_vendor_qcom_sdclang prebuilts/clang/host/linux-x86/12.1.0
echo cloning done for clang

# saving ccache
echo Hmm time saving ccache
export USE_CCACHE=1
export CCACHE_EXEC=$(command -v ccache)
ccache -M 50G

# its build time
echo Very well its build time
. build/envsetup.sh
lunch havoc_mido-user
time brunch havoc_mido-user

# upload to gdrive
echo uploading build to Google drive
gdrive upload -p 1O3K6ct5Y4ggDqESCDmMldd6otZOvlTOi ./out/target/product/mido/Havoc*.zip
echo build uploaded to team drive now dont be fucking lazy go to grive and get download link
