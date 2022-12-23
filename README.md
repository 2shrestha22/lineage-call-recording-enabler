## Lineage Call Recording Enabler (Lineage Dialer RRO)
This is a [Runtime Resource Overlay](https://source.android.com/docs/core/runtime/rros) for the dialer app in LineageOS to enable call recording in all countries.

LineageOS native call recording is enabled or disabled depending on your current location and the those countries are listed here, https://github.com/LineageOS/android_packages_apps_Dialer/blob/lineage-19.1/java/com/android/dialer/callrecord/res/xml/call_record_states.xml. One can enable or disable call recording by updating those values and this is what this overlay does.

## Runtime Resource Overlay
> A runtime resource overlay (RRO) is a package that changes the resource values of a target package at runtime. For example, an app installed on the system image might change its behavior based upon the value of a resource. Rather than hardcoding the resource value at build time, an RRO installed on a different partition can change the values of the app's resources at runtime.
One can enable or disable call recording by updating this file. However this overlay package changes the resource values of a target package at runtime.

https://source.android.com/docs/core/runtime/rros

## How to build overlay (optional)
**There is a prebuilt overlay APK, `flashable/system/vendor/overlay/lineage-dialer-rro.apk` so you don't need to build it again.**

Generate unsigned and unaligned APK.
```
aapt package -M AndroidManifest.xml -S res/ \
    -I ~/Android/Sdk/platforms/android-33/android.jar \
    -F lineage-dialer-rro.apk.u
```

Sign the APK. Password for debug keystore is android.
```
jarsigner -keystore ~/.android/debug.keystore \
    lineage-dialer-rro.apk.u androiddebugkey
```

Align the APK.
```
zipalign 4 lineage-dialer-rro.apk.u lineage-dialer-rro.apk
```
You can find `aapt` and `zipalign` inside build-tool of Android SDK installation dir. e.g. `~/Android/Sdk/build-tools/33.0.0/`

## How to install

### a. Manual
* Restart ADB with root privileges:  
`adb root`

* Mount the vendor folder as read-write:  
`adb shell mount -o rw,remount /vendor`

* Copy the required package to the overlay folder:  
`adb push lineage-dialer-rro.apk /vendor/overlay`

* Verify if the correct permissions are set (optional):  
`adb shell stat /vendor/overlay/lineage-dialer-rro.apk | grep "0644"`

* Mount the system as read-write:  
`adb shell mount -o rw,remount /`

* Copy the OTA survival script to the appropriate location:  
`adb push 99-lineage-dialer-rro.sh /system/addon.d`

* Make the script executable:  
`adb shell chmod 755 /system/addon.d/99-lineage-dialer-rro.sh`

* Verify if the correct permissions are set (optional):  
`adb shell stat /system/addon.d/99-lineage-dialer-rro.sh | grep "0755"`

* After all the files have been copied, reboot the device:  
`adb reboot`

### b. Flashable zip
* Create zip:  
`7za a -tzip -r lineage-dialer-rro.zip ./flashable/*`

* Sign:  
`java -jar ./bin/zipsigner.jar lineage-dialer-rro.zip lineage-dialer-rro-signed.zip`

* Reboot to sideload mode:  
`adb reboot sideload`

* Sideload zip:  
`adb sideload lineage-dialer-rro-signed.zip`

## Resources:
update-binary: [MindTheGapps](https://gitlab.com/MindTheGapps/)

zipsigner: [Magisk (source)](https://github.com/topjohnwu/Magisk/tree/v20.4/signing), [XDA (binary)](https://forum.xda-developers.com/t/dev-template-complete-shell-script-flashable-zip-replacement-signing-script.2934449/)
