echo Verifying the boot mode:
sleep 2s
ls /sys/firmware/efi/efivars
sleep 5s

timedatectl set-ntp true

cgdisk /dev/sda
mkfs.fat -F 32 /dev/sda1
mkfs.btrfs /dev/sda2
mkfs.btrfs /dev/sda3
mount /dev/sda2 /mnt
mount /dev/sda3 /mnt/home
mount /dev/sda1 /mnt/boot

pacstrap /mnt base linux-lts linux-firmware vim nano micro 
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Tbilisi /etc/localtime
hwclock --systohc
micro /etc/locale.gen
locale-gen
micro /etc/locale.conf
mciro /etc/hostname
passwd
pacman -S grub
exit
umount -R /mnt
reboot
