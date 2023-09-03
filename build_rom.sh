# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/PixelExperience/manifest -b thirteen-plus -g default,-mips,-darwin,-notdefault --git-lfs
git clone https://github.com/snnbyyds/local_manifests.git --depth 1 -b thirteen-plus .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh

croot
export CUSTOM_BUILD_TYPE=OFFICIAL
lunch aosp_fajita-userdebug
export KBUILD_BUILD_USER=snnbyyds
export KBUILD_BUILD_HOST=uotan
export BUILD_USERNAME=snnbyyds
export BUILD_HOSTNAME=uotan
export TZ=Asia/Shanghai #put before last build command
mka bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
