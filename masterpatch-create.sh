#!/bin/bash

day=`date +%m.%d.%y`

# files to pull as arrays
system_bin=( mm-qcamera-app mm-qcamera-test mm-qcamera-daemon mm-qcamera-testsuite-client )
system_cameradata=( datapattern_420sp.yuv datapattern_front_420sp.yuv )
system_etc=( media_profiles.xml )
system_lib=( libchromatix_imx074_default_video.so libchromatix_imx074_preview.so libchromatix_imx074_video_hd.so libchromatix_imx074_zsl.so libchromatix_imx091_default_video.so libchromatix_imx091_preview.so libchromatix_imx091_video_hd.so libchromatix_mt9e013_default_video.so libchromatix_mt9e013_preview.so libchromatix_mt9e013_video_hfr.so libchromatix_ov2720_default_video.so libchromatix_ov2720_hfr.so libchromatix_ov2720_preview.so libchromatix_ov2720_zsl.so libchromatix_ov5647_default_video.so libchromatix_ov5647_preview.so libchromatix_ov8825_default_video.so libchromatix_ov8825_preview.so libchromatix_ov9726_default_video.so libchromatix_ov9726_preview.so libchromatix_s5k3h5xa_animation.so libchromatix_s5k3h5xa_antishake.so libchromatix_s5k3h5xa_default_video.so libchromatix_s5k3h5xa_lls.so libchromatix_s5k3h5xa_preview.so libchromatix_s5k3h5xa_zsl_drama.so libchromatix_s5k3h5xa_zsl_panorama.so libchromatix_s5k3h5xa_zsl.so libchromatix_s5k3l1yx_default_video.so libchromatix_s5k3l1yx_hfr_120fps.so libchromatix_s5k3l1yx_hfr_60fps.so libchromatix_s5k3l1yx_hfr_90fps.so libchromatix_s5k3l1yx_preview.so libchromatix_s5k3l1yx_video_hd.so libchromatix_s5k3l1yx_zsl.so libchromatix_s5k4e1_default_video.so libchromatix_s5k4e1_preview.so libchromatix_s5k6b2yx_pip.so libchromatix_s5k6b2yx_preview.so libchromatix_s5k6b2yx_smartstay.so libchromatix_s5k6b2yx_video.so libchromatix_s5k6b2yx_vt_hd.so libchromatix_s5k6b2yx_vt.so libgemini.so libimage-jpeg-enc-omx-comp.so libimage-omx-common.so libmercury.so libmmcamera_faceproc.so libmmcamera_frameproc.so libmmcamera_hdr_lib.so libmmcamera_image_stab.so libmmcamera_imx091.so libmmcamera_interface2.so libmmcamera_interface.so libmmcamera_plugin.so libmmcamera_statsproc31.so libmmcamera_wavelet_lib.so libmmjpeg_interface.so libmmjpeg.so libmmmpod.so libmmmpo.so libmmstillomx.so liboemcamera.so libsecnativefeature.so libTsAccm.so libTsAwb.so )
system_lib_hw=( camera.msm8960.so )
system_lib_modules=( dhd.ko scsi_wait_scan.ko )
system_lib_usr_keylayout=( gpio-keys.kl )

adb start-server
adb shell "su -c 'mount -o remount,rw /system'"
echo -e "Unlock your phone and make sure that you give ADB root permissions"
sleep 5
mkdir -p ~/android/masterpatch
cp ~/masterpatch-create/update-binary ~/android/masterpatch/
cur_path=${HOME}/android/masterpatch
mkdir -p ~/android/masterpatch/system/lib/usr/keylayout ~/android/masterpatch/system/lib/modules ~/android/masterpatch/system/lib/hw ~/android/masterpatch/system/bin ~/android/masterpatch/system/etc ~/android/masterpatch/system/cameradata

cd ${cur_path}/system/bin
for x in ${system_bin[@]}; do
  adb pull /system/bin/${x} ./
done

cd ${cur_path}/system/cameradata
for x in ${system_cameradata[@]}; do
  adb pull /system/cameradata/${x} ./
done

cd ${cur_path}/system/etc
for x in ${system_etc[@]}; do
  adb pull /system/etc/${x} ./
done

cd ${cur_path}/system/lib
for x in ${system_lib[@]}; do
  adb pull /system/lib/${x} ./
done

cd ${cur_path}/system/lib/hw
for x in ${system_lib_hw[@]}; do
  adb pull /system/lib/hw/${x} ./
done

cd ${cur_path}/system/lib/modules
for x in ${system_lib_modules[@]}; do
  adb pull /system/lib/modules/${x} ./
done

cd ${cur_path}/system/usr/keylayout
for x in ${system_usr_keylayout[@]}; do
  adb pull /system/usr/keylayout/${x} ./
done

cd $cur_path
mkdir -p META-INF/com/google/android
mv ./update-binary ./META-INF/com/google/android/
echo "ui_print("I537 MasterPatch for S4 ROMs");
ui_print("- By thisisapoorusernamechoice");
ui_print("Script by my-blue-snog-box");
show_progress(1.000000, 0);
ui_print("Mounting system");
mount("ext4", "EMMC", "/dev/block/platform/msm_sdcc.1/by-name/system", "/system");
set_progress(0.100000);
ui_print("Patching");
package_extract_dir("system", "/system");
set_progress(0.400000);
ui_print("Done!");
ui_print("Unmounting system");
unmount("/system");
ui_print("Please restart");
" > ./META-INF/com/google/android/updater-script
zip -rv ./masterpatch.${day}.zip ./META-INF ./system
rm -rf ./META-INF ./system

adb shell "su -c 'mount -o remount,ro /system'"
adb kill-server
echo -e "Master patch is done. It is located at ${cur_path}/masterpatch.${day}.zip"
