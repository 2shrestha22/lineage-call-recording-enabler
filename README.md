## How to build

Generate unsigned and unaligned APK.
```
~/Android/Sdk/build-tools/33.0.0/aapt package -M AndroidManifest.xml -S res/ \
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
~/Android/Sdk/build-tools/33.0.0/zipalign 4 lineage-dialer-rro.apk.u lineage-dialer-rro.apk
```

## How to install

### Manual installation
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

### Installation with Flashable zip (not tested)
* Create zip

`7za a -tzip -r lineage-dialer-rro.zip ./flashable/*`

* Sign

`java -jar ./bin/zipsigner.jar lineage-dialer-rro.zip lineage-dialer-rro-signed.zip`


## Resources:
update-binary: https://github.com/arovlad/bromite-webview-overlay

zip-signer: https://forum.xda-developers.com/t/dev-template-complete-shell-script-flashable-zip-replacement-signing-script.2934449/
