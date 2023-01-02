7za a -tzip -r lineage-dialer-rro_magisk.zip ./magisk/*
7za a -tzip -r lineage-dialer-rro_recovery.zip ./recovery/*
java -jar ./bin/zipsigner.jar lineage-dialer-rro_recovery.zip lineage-dialer-rro-signed_recovery.zip