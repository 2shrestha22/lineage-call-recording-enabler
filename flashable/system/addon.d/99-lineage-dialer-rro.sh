#!/sbin/sh
#
# ADDOND_VERSION=2
#
# /system/addon.d/99-lineage-dialer-rro.sh
# During a LineageOS upgrade, this script backs up /vendor/overlay/lineage-dialer-rro.apk,
# /system is formatted and reinstalled, then the file is restored.
#
# Copied from 50-lineage.sh

. /tmp/backuptool.functions

list_files() {
cat <<EOF
vendor/overlay/lineage-dialer-rro.apk
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/"$FILE"
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Stub
  ;;
esac
