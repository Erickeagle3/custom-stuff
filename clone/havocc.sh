echo cloning your chosen repo's
git clone https://github.com/Erickeagle3/device_xiaomi_mido -b havoc device/xiaomi/mido && git clone https://github.com/Erickeagle3/vendor_xiaomi vendor/xiaomi && rm -rf hardware/qcom-caf/msm8996/display hardware/qcom-caf/msm8996/audio hardware/qcom-caf/msm8996/media && git clone https://github.com/crdroidandroid/android_hardware_qcom_display.git -b 11.0-caf-msm8996 hardware/qcom-caf/msm8996/display && git clone https://github.com/crdroidandroid/android_hardware_qcom_audio -b 11.0-caf-msm8996 hardware/qcom-caf/msm8996/audio && git clone https://github.com/crdroidandroid/android_hardware_qcom_media.git -b 11.0-caf-msm8996 hardware/qcom-caf/msm8996/media && rm -rf frameworks/opt/telephony packages/services/Telephony && git clone https://github.com/crdroidandroid/android_packages_services_Telephony packages/services/Telephony && git clone https://github.com/crdroidandroid/android_frameworks_opt_telephony frameworks/opt/telephony && rm -rf vendor/qcom/opensource/power && git clone https://github.com/PixelExperience/vendor_qcom_opensource_power vendor/qcom/opensource/power && git clone https://github.com/Erickeagle3/kernel kernel/xiaomi/mido
echo downloading script.sh
curl 
