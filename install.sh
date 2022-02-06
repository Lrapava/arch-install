in_arch() {
	echo '
		ln -sf /usr/share/zoneinfo/Asia/Tbilisi /etc/localtime
		hwclock --systohc
		echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
		locale-gen
		echo "LANG=en_US.UTF-8" >> /etc/locale.conf
		echo "ravenholm" >> /etc/hostname
		echo "127.0.0.1	localhost" >> /etc/hosts
		echo "::1		localhost" >> /etc/hosts
		echo "127.0.1.1	ravenholm.localdomain	ravenholm" >> /etc/hosts
		passwd
		grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
		grub-mkconfig -o /boot/grub/grub.cfg
		exit
	'
}

timedatectl set-ntp true

fdisk /dev/sda
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3

mount /dev/sda2 /mnt
mkdir -p /mnt/boot /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home

pacstrap /mnt base linux linux-firmware micro nano vim grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers
genfstab -U /mnt >> /mnt/etc/fstab

in_arch | arch-chroot /mnt

umount -a
reboot
