#!/sbin/sh
#
# ThunderStorms Initial script
#

# Remove another kernel files
rm -f /system_root/system/etc/init/hw/init.spectrum.rc
rm -f /system_root/system/etc/init/hw/init.spectrum.sh
rm -f /system_root/system/etc/init/hw/init.services.rc
rm -f /system_root/system/etc/init/hw/init.ts.rc
rm -f /system_root/system/etc/init/hw/init.ts.sh
rm -f /system_root/system/etc/init/hw/init.custom.sh
rm -f /system_root/system/etc/init/hw/spa

# Remove imported services
sed -i '/import \/init.moro.rc/d' /system_root/system/etc/init/hw/init.rc
sed -i '/import \/init.spectrum.rc/d' /system_root/system/etc/init/hw/init.rc
sed -i '/import \/init.ts.rc/d' /system_root/system/etc/init/hw/init.rc
sed -i '/import \/init.services.rc/d' /system_root/system/etc/init/hw/init.rc
sed -i '/import \/init.custom.rc/d' /system_root/system/etc/init/hw/init.rc
sed -i '/init.moro.rc/d' /system_root/system/etc/init/hw/init.rc
sed -i '/init.spectrum.rc/d' /system_root/system/etc/init/hw/init.rc
sed -i '/init.ts.rc/d' /system_root/system/etc/init/hw/init.rc
sed -i '/init.services.rc/d' /system_root/system/etc/init/hw/init.rc
sed -i '/init.custom.rc/d' /system_root/system/etc/init/hw/init.rc

# Import init.ts.rc to init.rc
# sed -i '/import \/prism\/etc\/init\/init.rc/a\import \/init.custom.rc' /system_root/system/etc/init/hw/init.rc
sed -i '/import \/init.container.rc/a\import \/system\/etc\/init\/hw\/init.custom.rc' /system_root/system/etc/init/hw/init.rc






