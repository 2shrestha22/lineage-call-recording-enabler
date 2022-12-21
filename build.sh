7za a -tzip -r lineage-dialer-rro.zip ./flashable/*
java -jar ./bin/zipsigner.jar lineage-dialer-rro.zip lineage-dialer-rro-signed.zip
rm lineage-dialer-rro.zip