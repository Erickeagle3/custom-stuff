# saving ccache
echo Hmm time saving ccache
export USE_CCACHE=1
export CCACHE_EXEC=$(command -v ccache)
ccache -M 50G

# its build time
echo Very well its build time
. build/envsetup.sh
lunch bliss_mido-user
time blissify bliss_mido

# upload to gdrive
echo uploading build to Google drive
gdrive upload -p 1O3K6ct5Y4ggDqESCDmMldd6otZOvlTOi ./out/target/product/mido/Havoc*.zip
echo build uploaded to team drive now dont be fucking lazy go to grive and get download link
