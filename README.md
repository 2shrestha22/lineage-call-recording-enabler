## How to build

Generate unsigned and unaligned APK.
```
aapt package -M AndroidManifest.xml -S res/ \
    -I ~/Android/Sdk/platforms/android-23/android.jar \
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
`adb push 99-lineage-call-record.sh /system/addon.d`

* Make the script executable:  
`adb shell chmod 755 /system/addon.d/99-lineage-call-record.sh`

* Verify if the correct permissions are set (optional):  
`adb shell stat /system/addon.d/99-lineage-call-record.sh | grep "0755"`

* After all the files have been copied, reboot the device:  
`adb reboot`