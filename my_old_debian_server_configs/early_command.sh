#!/bin/sh

logger early_command partition configuration starting
( \
  set -x
  anna-install partman-lvm parted-udeb
#  for LVM in `lvs --noheadings --options lv_path`; do lvremove -f $LVM; done
#  for VG in `vgs --noheadings --options vg_name`; do vgremove -f $VG; done
#  for PV in `pvs --noheadings --options pv_name`; do pvremove -ff -y $PV; done
#  mdadm --stop /dev/md0
#  mdadm --stop /dev/md1
#  mdadm --zero-superblock /dev/sd[ab]1 /dev/sd[ab]2
  dd if=/dev/zero of=/dev/sda bs=1M count=520
  dd if=/dev/zero of=/dev/sdb bs=1M count=520
  parted /dev/sda -- mklabel msdos
  parted /dev/sdb -- mklabel msdos

  parted /dev/sdc -- mklabel msdos
  parted /dev/sdc -- mkpart primary ext2 1 -1
  mkfs.ext4 -q -L data2 /dev/sdc1

  parted /dev/sda -- mkpart primary ext2 1 512M
  parted /dev/sda -- set 1 raid on
  parted /dev/sda -- mkpart primary ext2 512M -1
  parted /dev/sda -- set 2 raid on
#  echo -e "p \n n \n p \n 1 \n \n +512M \n n \n p \n 2 \n \n \n t \n 1 \n fd \n t \n 2 \n fd \n p \n w \n" | fdisk /dev/sda
  sfdisk --quiet -d /dev/sda | sfdisk /dev/sdb
  echo -e "n \n p \n 3 \n \n \n p \n w \n" | fdisk /dev/sdb
  sync; sleep 5; sync
  echo y | mdadm --create /dev/md0 --chunk=64 --metadata=1 --level=raid1 --raid-devices=2 /dev/sda1 missing
  #/dev/sdb1
  echo y | mdadm --create /dev/md1 --chunk=64 --metadata=1 --level=raid1 --raid-devices=2 /dev/sda2 missing
  #/dev/sdb2
  pvcreate /dev/md1
  vgcreate vg00 /dev/md1
  lvcreate -n root -L 1G vg00
  lvcreate -n tmp -L 1G vg00
  lvcreate -n var -L 10G vg00
  lvcreate -n usr -L 5G vg00
  lvcreate -n swap -L 1G vg00
  lvcreate -n home -l 100%FREE vg00
  mkswap -L swap /dev/mapper/vg00-swap

# Mounting filesystems
#  mkdir /target
#  mount -t ext4 /dev/mapper/vg00-root /target
#  mkdir -p /target/boot /target/tmp /target/var /target/usr /target/home/data
#  mount -t ext4 /dev/md0 /target/boot
#  mount -t ext4 /dev/mapper/vg00-tmp /target/tmp
#  mount -t ext4 /dev/mapper/vg00-var /target/var
#  mount -t ext4 /dev/mapper/vg00-usr /target/usr
#  mount -t ext4 /dev/mapper/vg00-home /target/home
#  swapon /dev/mapper/vg00-swap

# Creating fstab
#  mkdir /target/etc
#  echo proc                     /proc           proc    defaults                               0 0 >> /target/etc/fstab
#  echo /dev/mapper/vg00-root    /               ext4    errors=remount-ro,,noatime,nodiratime  0 1 >> /target/etc/fstab
#  echo LABEL="boot"             /boot           ext4    defaults,noatime,nodiratime            1 2 >> /target/etc/fstab
#  echo /dev/mapper/vg00-home    /home           ext4    defaults,noatime,nodiratime            0 2 >> /target/etc/fstab
#  echo /dev/mapper/vg00-tmp     /tmp            ext4    defaults,noatime,nodiratime            0 2 >> /target/etc/fstab
#  echo /dev/mapper/vg00-usr     /usr            ext4    defaults,noatime,nodiratime            0 2 >> /target/etc/fstab
#  echo /dev/mapper/vg00-var     /var            ext4    defaults,noatime,nodiratime            0 2 >> /target/etc/fstab
#  echo /dev/mapper/vg00-swap    none            swap    sw                                     0 0 >> /target/etc/fstab
#  echo LABEL="data"             /home/data      ext4    defaults,noatime,nodiratime            0 2 >> /target/etc/fstab
#  echo /dev/cdrom               /media/cdrom0   iso9660 user,noauto                            0 0 >> /target/etc/fstab

) 1>> /tmp/part.log 2>> /tmp/part.log;

mkdir /target/root
cp /tmp/part.log /target/root/
