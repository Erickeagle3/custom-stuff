#!/bin/bash

# saving ccache
echo Hmm time saving ccache
export USE_CCACHE=1
export CCACHE_EXEC=$(command -v ccache)
ccache -M 50G 

# its build time 
echo Very well its build time
. build/envsetup.sh
lunch aicp_mido-user
time brunch aicp_mido-user

# upload to gdrive 
echo uploading build to Google drive check here https://test-builds.hopperjames.workers.dev/0:/
gdrive upload -p 1O3K6ct5Y4ggDqESCDmMldd6otZOvlTOi ./out/target/product/mido/aicp_mido_r-16.1-UNOFFICIAL-20210515.zip
echo build uploaded to https://test-builds.hopperjames.workers.dev/0:/aicp_mido_r-16.1-UNOFFICIAL-20210515.zip
