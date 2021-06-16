#!/bin/bash

# User Defined Stuff

folder="/home2/eric/havoc"
rom_name="Havoc*.zip"
gapps_command="no"
with_gapps="no"
build_type="user"
device_codename="mido"
use_brunch="yes"
OUT_PATH="$folder/out/target/product/${device_codename}"
lunch="havoc"
user="eric"
tg_username="@NBD_ERICK"
ccache_location=${folder}/../ccache # Default you can change it 

# make_clean="yes"
# make_clean="no"
# make_clean="installclean"

# Rom being built

ROM=${OUT_PATH}/${rom_name}

# Telegram Stuff

priv_to_me="/home/dump/configs_iron/priv.conf"
channel="/home/dump/configs_iron/channel.conf"
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
telegram-send --format html "${msg}" --config ${channel} --disable-web-page-preview
telegram-send --format html "${msg}" --config ${newpeeps} --disable-web-page-preview

# Time to build

if [ -d ${folder}/"out" ]
then
    echo "Out folder  exists."
else
	sudo mkdir ${folder}/"out"
	sudo chown -R jenkins:jenkins ${folder}/"out" &&  sudo chmod -R 777 ${folder}/"out"
    echo "Made out Folder "
fi
if [ -d ${ccache_location} ]
then
    echo "Ccache folder  exists."
else
	sudo mkdir ${ccache_location}
	sudo chown -R jenkins:jenkins ${ccache_location} &&  sudo chmod -R 777 ${ccache_location}
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
rm -rf ${OUT_PATH} ${folder}/*log  ${folder}/*gz    ${folder}/*ninja
echo -e ${cya}"Clean Build"${txtrst};
fi

if [ "$make_clean" = "installclean" ];
then
rm -rf ${OUT_PATH}
echo -e ${cya}"Install Clean"${txtrst};
fi

rm -rf ${OUT_PATH}/*.zip
lunch ${lunch}_${device_codename}-${build_type}

# Brunch Options

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
telegram-send --format html "$priv" --config ${channel} --disable-web-page-preview
telegram-send --format html "$priv" --config ${newpeeps} --disable-web-page-preview
