#!/bin/bash

# This Script needs one change from the users and have some instructions how to use it, so please do read first 10 Lines of the Script.

# Clone this script in your ROM Repo using following commands.
# cd rom_repo
# curl https://raw.githubusercontent.com/LegacyServer/Scripts/master/script_build.sh > script_build.sh

# Some User's Details. Please fill it with your own details.

# Replace "legacy" with your own SSH Username in lowercase
username=legacy

# Colors makes things beautiful
export TERM=xterm

    red=$(tput setaf 1)             #  red
    grn=$(tput setaf 2)             #  green
    blu=$(tput setaf 4)             #  blue
    cya=$(tput setaf 6)             #  cyan
    txtrst=$(tput sgr0)             #  Reset

# CCACHE UMMM!!! Cooks my builds fast

if [ "$use_ccache" = "yes" ];
then
echo -e ${blu}"CCACHE is enabled for this build"${txtrst}
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
export CCACHE_DIR=/home/ccache/$username
ccache -M 75G
fi

if [ "$use_ccache" = "clean" ];
then
export CCACHE_EXEC=$(which ccache)
export CCACHE_DIR=/home/ccache/$username
ccache -C
export USE_CCACHE=1
ccache -M 75G
wait
echo -e ${grn}"CCACHE Cleared"${txtrst};
fi

# Prepare Environment and Device
source build/envsetup.sh
lunch "$lunch_command"_"$device_codename"-"$build_type"

# Its Clean Time
if [ "$make_clean" = "yes" ];
then
make clean && make clobber
wait
echo -e ${cya}"OUT dir from your repo deleted"${txtrst};
fi

# Its Images Clean Time
if [ "$make_clean" = "installclean" ];
then
make installclean
wait
echo -e ${cya}"Images deleted from OUT dir"${txtrst};
fi

# Build ROM
make "$target_command" -j"$jobs"

# upload to gdrive
echo uploading build to Google drive
/home/sayan/gdrive -c /home/sayan/.gdrive/ upload -p 1QlRWUgvKiUvgsexMGtlhX4hX1j5EroFa ./out/target/product/mido/Havoc*.zip

echo here is the link of G Index  https://test-builds.aijarvis334.workers.dev/
echo here is the link of Google Drive - https://drive.google.com/drive/u/3/folders/1QlRWUgvKiUvgsexMGtlhX4hX1j5EroFa
