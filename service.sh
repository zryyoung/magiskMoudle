#!/system/bin/sh
TeamS=${0%/*}
chmod -R 755 "$TeamS"

# in case of /data encryption is disabled
While() {
	[ "$(getprop sys.boot_completed)" != 1 ] && {
		sleep 15s
		While
	}
}

BASEDIR="$(dirname $(readlink -f "$0"))"

function boot(){
while true;
do
btcplt=$(getprop vendor.oplus.boot_complete)
if [ "$btcplt" -eq "1" ];then
	return 0
fi
sleep 1
done
}

settings put system peak_refresh_rate 120.9
settings put system min_refresh_rate 120.9

boot

settings put system peak_refresh_rate 120.9
settings put system min_refresh_rate 120.9

echo 4095 >/sys/kernel/oplus_display/max_brightness

#添加其他通用shell 命令






echo 1 > /proc/sys/walt/sched_conservative_pl

sleep 15
echo 0 > /proc/sys/walt/sched_boost
echo 8 > /proc/sys/walt/input_boost/sched_boost_on_input

While

{
	#Use system interpreter
	/system/bin/sh "$TeamS/activity_diaodu.rc" &
	#Leave the process
	exit 0
}
