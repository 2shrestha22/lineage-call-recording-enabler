## Lineage Call Recording Enabler (Lineage Dialer RRO)

This is a [Runtime Resource Overlay](https://source.android.com/docs/core/runtime/rros) for the dialer app in LineageOS to enable call recording in all countries.

LineageOS native call recording is enabled or disabled depending on your current location and the those countries are listed here, https://github.com/LineageOS/android_packages_apps_Dialer/blob/lineage-19.1/java/com/android/dialer/callrecord/res/xml/call_record_states.xml. One can enable or disable call recording by updating those values and this is what this overlay does.

## Runtime Resource Overlay

> A runtime resource overlay (RRO) is a package that changes the resource values of a target package at runtime. For example, an app installed on the system image might change its behavior based upon the value of a resource. Rather than hardcoding the resource value at build time, an RRO installed on a different partition can change the values of the app's resources at runtime.

One can enable or disable call recording by updating this file. However this overlay package changes the resource values of a target package at runtime.

https://source.android.com/docs/core/runtime/rros

## Usage

Get flashable zip or magisk module from here https://github.com/2shrestha22/lineage-call-recording-enabler/releases

### a. Magisk

- If you have magisk installed you can use the magisk module. Download the module from releases.

### b. Flashable zip

- Reboot to sideload mode:  
  `adb reboot sideload`

- Sideload zip (or flash from recovery):  
  `adb sideload lineage-dialer-rro_recovery.zip`

### c. Manual (try this when nothing worked)

Overlay APK can be found in `recovery/system/product/overlay/DialerCallRecordingAllowed.apk`.

- Restart ADB with root privileges:  
  `adb root`

- Mount the product folder as read-write:  
  `adb shell mount -o rw,remount /product`

- Copy the required package to the overlay folder:  
  `adb push DialerCallRecordingAllowed.apk /product/overlay`

- Verify if the correct permissions are set (optional):  
  `adb shell stat /product/overlay/DialerCallRecordingAllowed.apk | grep "0644"`

- Mount the system as read-write:  
  `adb shell mount -o rw,remount /`

- Copy the OTA survival script to the appropriate location:  
  `adb push 20-call-recording.sh /system/addon.d`

- Make the script executable:  
  `adb shell chmod 755 /system/addon.d/20-call-recording.sh`

- Verify if the correct permissions are set (optional):  
  `adb shell stat /system/addon.d/20-call-recording.sh | grep "0755"`

- After all the files have been copied, reboot the device:  
  `adb reboot`

## Build it yourself (OPTIONAL)

You can compile overlay APK and package it to flashabel zip magisk module yourself. A prebuilt overlay APK can be found in `recovery/system/product/overlay/DialerCallRecordingAllowed.apk`.

### Compile overlay APK

Generate unsigned and unaligned APK.

```
aapt package -M AndroidManifest.xml -S res/ \
    -I ~/Android/Sdk/platforms/android-33/android.jar \
    -F DialerCallRecordingAllowed.apk.u
```

Sign the APK. Password for debug keystore is android.

```
jarsigner -keystore ~/.android/debug.keystore \
    DialerCallRecordingAllowed.apk.u androiddebugkey
```

Align the APK.

```
zipalign 4 DialerCallRecordingAllowed.apk.u DialerCallRecordingAllowed.apk
```

You can find `aapt` and `zipalign` inside build-tool of Android SDK installation dir. e.g. `~/Android/Sdk/build-tools/33.0.0/`

### Create flashable zip

- Create zip:  
  `7za a -tzip -r lineage-dialer-rro_recovery.zip ./recovery/*`

- Sign:  
  `java -jar ./bin/zipsigner.jar lineage-dialer-rro_recovery.zip lineage-dialer-rro-signed_recovery.zip`

### Create magisk module

- Create zip:  
  `7za a -tzip -r lineage-dialer-rro_magisk.zip ./magisk/*`

## Resources:

update-binary: [MindTheGapps](https://gitlab.com/MindTheGapps/vendor_gapps/-/blob/vic/build/meta/com/google/android/update-binary)

magisk: [Developer Guides](https://topjohnwu.github.io/Magisk/guides.html)

zipsigner: [Magisk (source)](https://github.com/topjohnwu/Magisk/tree/v20.4/signing), [XDA (binary)](https://forum.xda-developers.com/t/dev-template-complete-shell-script-flashable-zip-replacement-signing-script.2934449/)
