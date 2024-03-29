#!/bin/bash

# User Defined Stuff

folder="/home2/eric/cr"
rom_name="crDroid*.zip"
gapps_command="no"
with_gapps="no"
build_type="userdebug"
device_codename="mido"
use_brunch="yes"
OUT_PATH="$folder/out/target/product/${device_codename}"
lunch="lineage"
user="eric"
tg_username="@NBD_ERICK"

# Default you can change it 

ccache_location=${folder}/../ccache 

# Make Clean , options uncomment  to chose 

# make_clean="yes"
# make_clean="no"
# make_clean="installclean"

# Rom being built

ROM=${OUT_PATH}/${rom_name}

# Telegram Stuff

priv_to_me="/home/dump/configs_iron/priv.conf"
newpeeps="/home2/eric/pric.conf"

# Folder specifity

cd "$folder"

echo -e "\rBuild starting thank you for waiting"
BLINK="https://ci.goindi.org/job/$JOB_NAME/$BUILD_ID/console"

# Send message to TG

read -r -d '' msg <<EOT
<b>Build Started</b>
<b>Device:-</b> ${device_codename}
<b>Started by:-</b> ${tg_username}
<b>Console log:-</b> <a href="${BLINK}">here</a>
EOT

telegram-send --format html "${msg}" --config ${priv_to_me} --disable-web-page-preview
telegram-send --format html "${msg}" --config ${newpeeps} --disable-web-page-preview

# Time to build

if [ -d ${ccache_location} ]
then
        echo "Ccache folder  exists."
else
        sudo chmod -R 777 ${ccache_location}
        echo "Made Ccache Folder "
fi
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
export CCACHE_DIR=${ccache_location}
ccache -M 75G

source build/envsetup.sh

if [ "$with_gapps" = "yes" ];
then
export "$gapps_command"=true
export TARGET_GAPPS_ARCH=arm64
fi

if [ "$with_gapps" = "no" ];
then
export "$gapps_command"=false
fi

# Clean build

if [ "$make_clean" = "yes" ];
then
rm -rf out 
echo -e "Clean Build";
fi

if [ "$make_clean" = "installclean" ];
then
rm -rf ${OUT_PATH}
echo -e "Install Clean";
fi

rm -rf ${OUT_PATH}/*.zip
lunch ${lunch}_${device_codename}-${build_type}

# Build Options

START=$(date +%s)
if [ "$use_brunch" = "yes" ];
then
brunch ${device_codename} 
fi

if [ "$use_brunch" = "no" ];
then
make  ${lunch} -j$(nproc --all) 
fi

if [ "$use_brunch" = "bacon" ];
then
make bacon -j$(nproc --all) 
fi
END=$(date +%s)
TIME=$(echo $((${END}-${START})) | awk '{print int($1/60)" Minutes and "int($1%60)" Seconds"}')

if [ -f $ROM ]; then

mkdir -p /home/dump/sites/goindi/downloads/${user}/${device_codename}
cp $ROM /home/dump/sites/goindi/downloads/${user}/${device_codename}
filename="$(basename $ROM)"
LINK="https://download.goindi.org/${user}/${device_codename}/${filename}"
read -r -d '' priv <<EOT
<b>Build Finished</b>
<b>Build Time:-</b> ${TIME}
<b>Device:-</b> ${device_codename}
<b>Started by:-</b> ${tg_username}
<b>Download:-</b> <a href="${LINK}">here</a>
EOT

else

# Send message to TG

read -r -d '' priv <<EOT
<b>Build Errored</b>
<b>Build Time:-</b> ${TIME}
<b>Device:-</b> ${device_codename}
<b>Started by:-</b> ${tg_username}
<b>Check error:-</b> <a href="https://ci.goindi.org/job/$JOB_NAME/$BUILD_ID/console">here</a>
EOT
fi

telegram-send --format html "$priv" --config ${priv_to_me} --disable-web-page-preview
telegram-send --format html "$priv" --config ${newpeeps} --disable-web-page-preview
