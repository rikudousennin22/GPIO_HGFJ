# GPIO_HGFJ
kernel 5.15

> [!IMPORTANT]
> You must enable the `MT7668S WiFi Meson G12A workaround` at compile time if your target device is Amlogic g12a.
>
> DO NOT ENABLE FOR OTHER TARGETS as it will degrade WiFi performance.

<!-- 5. **Compile the kernel as usual.**

## Usage

After installing and loading the driver, you can configure the WiFi settings using standard Linux networking tools such as `iwconfig` or `nmcli`. For OpenWrt, the configuration can be done via the LuCI interface or by editing `/etc/config/wireless`.

## Troubleshooting

If you encounter any issues, please check the following:

- Ensure that your kernel version is compatible with the driver.
- Check the system logs for any error messages related to the driver.
-->

## Contributing

If you find any issues or have suggestions for improvements, please submit a pull request or open an issue in the repository.

## Acknowledgements

Special thanks to:

- MediaTek Inc.
- Amazon Inc.
- [DBAI](https://github.com/armarchindo)
- Everyone who is contributing to porting this driver to Linux

## License

- Original FOSS code from MediaTek Ltd. is licensed under the [GPLv2 License](LICENSE), yet firmware files are licensed under Dual License BSD/GPL.
- This project is also licensed under the [GPLv2 License](LICENSE).

## Build Openwrt
- git clone https://github.com/yhpgi/linux-6.6.y.git
- cd linux-6.6.y
- sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
- sudo apt install build-essential flex bison libssl-dev libelf-dev bc
- sudo apt install libncurses-dev pkg-config
- sudo apt install u-boot-tools
- export ARCH=arm64
- export CROSS_COMPILE=aarch64-linux-gnu-
- cd /linux-6.6.y/drivers/net/wireless/mediatek/
- git clone https://github.com/yhpgi/mt7668s.git
- cd /linux-6.6.y
- make ARCH=arm64 defconfig
- make ARCH=arm64 menuconfig
- make ARCH=arm64 -j$(nproc)
- make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig	run perintah mu
- make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
- find -name "*.ko" -exec aarch64-linux-gnu-strip --strip-debug {} \;
- make modules_install INSTALL_MOD_PATH=./Build
- cd Build
- cp -r * /mnt/c/Users/Aditya/Downloads/Build/

- /////////////Untuk Meng compres katanya////////////////////
- find /home/willy/rootfs/lib/modules/ -name "*.ko" -exec aarch64-linux-gnu-strip --strip-debug {} \;

- make clean
- make ARCH=arm64 mrproper
- find . -name "*.o" -o -name "*.ko" -o -name "*.mod.c" -o -name "*.symvers" -o -name "*.cmd" -delete

- wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.89.tar.xz
- tar -xf linux-6.6.89.tar.xz  
- cd linux-6.6.89.tar


- cd drivers/net/wireless/mediatek/
- git clone https://github.com/yhpgi/mt7668s.git

- hostapd -dd /etc/hostapd/phy0-ap0.conf
- CONFIG_CFG80211=y
- CONFIG_MAC80211=y
## Mengatasi Premission Denied
- pakai wpad jangan hostapd
/ etc / init.d : wpad

# Custom `wpad` Init Script for OpenWRT

Skrip ini merupakan skrip init (`/etc/init.d/wpad`) untuk memulai layanan `hostapd` dan `wpa_supplicant` secara terintegrasi menggunakan `procd` di OpenWRT. 

Fitur:
- Memulai `hostapd` jika tersedia, untuk mode Access Point.
- Memulai `wpa_supplicant` jika tersedia, untuk mode Client.
- Mendukung sandboxing (dengan `ujail`) dan konfigurasi kemampuan Linux (capabilities).
- Menyediakan direktori socket global dan pengaturan `respawn`.

## Cara Menggunakan

1. Simpan skrip di bawah ini ke dalam file `/etc/init.d/wpad`:

    ````sh
    #!/bin/sh /etc/rc.common
    START=19
    STOP=21

    USE_PROCD=1
    NAME=wpad

    start_service() {
        if [ -x "/usr/sbin/hostapd" ]; then
            mkdir -p /var/run/hostapd
            # chown network:network /var/run/hostapd
            procd_open_instance hostapd
            procd_set_param command /usr/sbin/hostapd -s -g /var/run/hostapd/global
            procd_set_param respawn 3600 1 0
            procd_set_param limits core="unlimited"
            # Jalankan langsung sebagai root, tanpa sandbox
            # [ -x /sbin/ujail -a -e /etc/capabilities/wpad.json ] && {
            #     procd_add_jail hostapd
            #     procd_set_param capabilities /etc/capabilities/wpad.json
            #     procd_set_param user network
            #     procd_set_param group network
            #     procd_set_param no_new_privs 1
            # }
            procd_close_instance
        fi

        if [ -x "/usr/sbin/wpa_supplicant" ]; then
            mkdir -p /var/run/wpa_supplicant
            chown network:network /var/run/wpa_supplicant
            procd_open_instance supplicant
            procd_set_param command /usr/sbin/wpa_supplicant -n -s -g /var/run/wpa_supplicant/global
            procd_set_param respawn 3600 1 0
            procd_set_param limits core="unlimited"
            [ -x /sbin/ujail -a -e /etc/capabilities/wpad.json ] && {
                procd_add_jail wpa_supplicant
                procd_set_param capabilities /etc/capabilities/wpad.json
                procd_set_param user network
                procd_set_param group network
                procd_set_param no_new_privs 1
            }
            procd_close_instance
        fi
    }
    ````

2. Jadikan skrip tersebut dapat dieksekusi:

    ```sh
    chmod +x /etc/init.d/wpad
    ```

3. Tambahkan ke autostart saat boot:

    ```sh
    /etc/init.d/wpad enable
    ```

4. Jalankan layanan:

    ```sh
    /etc/init.d/wpad start
    ```

## Catatan

- Direktori `/var/run/hostapd` dan `/var/run/wpa_supplicant` wajib ada agar socket global bisa dibuat.
- Bagian `ujail` dan `capabilities` akan aktif jika sistem mendukung sandboxing.
- Anda bisa membuka komentar `chown` jika menemukan masalah izin socket saat menggunakan `hostapd`.

---

**Lisensi**: Bebas digunakan dan dimodifikasi.


jalankan

- rm -rf /var/run/hostapd
- /etc/init.d/wpad stop
- /etc/init.d/wpad start
