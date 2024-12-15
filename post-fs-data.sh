MODDIR=${0%/*}
mount --bind $MODDIR/odm/bin/hw/vendor.oplus.hardware.gameopt-service /odm/bin/hw/vendor.oplus.hardware.gameopt-service
mount --bind $MODDIR/odm/bin/hw/vendor.oplus.hardware.urcc-service /odm/bin/hw/vendor.oplus.hardware.urcc-service
mount --bind $MODDIR/system_ext/bin/oiface /system_ext/bin/oiface

mount --bind $MODDIR/odm/lib64/libosensenativeproxy_client.so /odm/lib64/libosensenativeproxy_client.so 
mount --bind $MODDIR/odm/lib64/vendor.oplus.hardware.urcc-V1-ndk.so /odm/lib64/vendor.oplus.hardware.urcc-V1-ndk.so
mount --bind $MODDIR/odm/lib64/vendor.oplus.hardware.gameopt-V1-ndk.so /odm/lib64/vendor.oplus.hardware.gameopt-V1-ndk.so
mount --bind $MODDIR/odm/lib64/liboplus-uah-client.so /odm/lib64/liboplus-uah-client.so

mount --bind $MODDIR/system_ext/lib64/libbsproxy.so /system_ext/lib64/libbsproxy.so
mount --bind $MODDIR/system_ext/lib64/vendor.qti.qegahal-V1-ndk_platform.so /system_ext/lib64/vendor.qti.qegahal-V1-ndk_platform.so
mount --bind $MODDIR/system_ext/lib64/vendor.oplus.hardware.urcc-V1-ndk.so /system_ext/lib64/vendor.oplus.hardware.urcc-V1-ndk.so
mount --bind $MODDIR/system_ext/lib64/vendor.oplus.hardware.stability.oplus_project-V1-ndk.so /system_ext/lib64/vendor.oplus.hardware.stability.oplus_project-V1-ndk.so
mount --bind $MODDIR/system_ext/lib64/vendor.oplus.hardware.gameopt-V1-ndk.so /system_ext/lib64/vendor.oplus.hardware.gameopt-V1-ndk.so
mount --bind $MODDIR/system_ext/lib64/liboplus-uah-client.so /system_ext/lib64/liboplus-uah-client.so

mount --bind $MODDIR/my_product/etc/refresh_rate_config.xml /my_product/etc/refresh_rate_config.xml
mount --bind $MODDIR/my_product/etc/oplus_vrr_config.json /my_product/etc/oplus_vrr_config.json

mount --bind $MODDIR/my_product/vendor/etc/display_brightness_app_list.xml /my_product/vendor/etc/display_brightness_app_list.xml
mount --bind $MODDIR/my_product/vendor/etc/display_brightness_config_P_3.xml /my_product/vendor/etc/display_brightness_config_P_3.xml
mount --bind $MODDIR/my_product/vendor/etc/multimedia_display_feature_config.xml multimedia_display_feature_config.xml
mount --bind $MODDIR/my_product/vendor/etc/multimedia_display_trackpoint_config.xml /my_product/vendor/etc/multimedia_display_trackpoint_config.xml
mount --bind $MODDIR/my_product/vendor/etc/multimedia_pixelworks_game_apps.xml /my_product/vendor/etc/multimedia_pixelworks_game_apps.xml

mount --bind $MODDIR/system/vendor/etc/perf/perfboostsconfig.xml /system/vendor/etc/perf/perfboostsconfig.xml
mount --bind $MODDIR/system/vendor/etc/perf/perfconfigstore.xml /system/vendor/etc/perf/perfconfigstore.xml

#给执行权限
chmod 777 /odm/bin/hw/vendor.oplus.hardware.gameopt-service
chmod 777 /data/adb/modules/muronggameopt/odm/bin/hw/vendor.oplus.hardware.urcc-service
chmod 777 /data/adb/modules/muronggameopt/system_ext/bin/oiface
# 直接执行二进制文件
/data/adb/modules/muronggameopt/odm/bin/hw/vendor.oplus.hardware.urcc-service &
/odm/bin/hw/vendor.oplus.hardware.gameopt-service &
/data/adb/modules/muronggameopt/system_ext/bin/oiface &