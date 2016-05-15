#!/bin/bash

# zfs send tank/backup@today | zfs recv usb/backup
orig_pool="original pool"
recv_pool="receiving pool"
filesystems=(
  the
  filesystems
  to
  backup
)

for filesystem in "${filesystems[@]}"
do
  zfs destroy $orig_pool/$filesystem@yesterday
  zfs rename $orig_pool/$filesystem@today @yesterday
  zfs snapshot $orig_pool/$filesystem@today

  zfs destroy $recv_pool/$filesystem@yesterday
  zfs rename $recv_pool/$filesystem@today @yesterday

  zfs send -i $orig_pool/$filesystem@yesterday $orig_pool/$filesystem@today | zfs recv $recv_pool/$filesystem
done
