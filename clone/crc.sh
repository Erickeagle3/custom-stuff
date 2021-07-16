echo cloning your repo's
git clone https://github.com/Erickeagle3/device_xiaomi_mido -b cr7 device/xiaomi/mido && git clone https://github.com/Erickeagle3/vendor_xiaomi vendor/xiaomi && git clone https://github.com/zeelog/android_kernel_xiaomi_mido.git kernel/xiaomi/mido
echo cloning repo's done now time to download build script
curl https://raw.githubusercontent.com/Erickeagle3/custom-stuff/main/legacy-script/cr.script?token=ALSXYL67ARZCKKBGBWHABQDA6EVJ2 > b.sh
