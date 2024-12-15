#!/system/bin/sh
module=/data/adb/modules/murongdiaodu

# 设置脚本的工作目录
D_PATH="$(
	cd $(dirname $0)
	pwd
)"
D_PATH=${D_PATH/'/storage/emulated/'/'/data/media/'}
D_PATH=${D_PATH/'/sdcard/'/'/data/media/0/'}
D_PATH="$(dirname "$(readlink -f "$0")")"

# 日志文件路径
LOG_FILE="/data/media/0/Android/muronggameopt/log.txt"

# 记录日志的函数
Log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# 执行命令
(

	Start() {
		# 获取并设置模式
		TXT_FILE="/data/media/0/Android/muronggameopt/mode.txt"
		if [ ! -f "$TXT_FILE" ]; then
			echo "File not found: $TXT_FILE"
			exit 1
		fi
		MODE=$(cat "$TXT_FILE")

		# 检测前台应用并根据diymode.txt切换模式
		DIY_MODE_FILE="/data/media/0/Android/muronggameopt/diymode.txt"
		if [ -f "$DIY_MODE_FILE" ]; then
			# 获取前台应用包名
			FG_APP=$(dumpsys window | grep mCurrentFocus | awk '{print $3}' | awk -F/ '{print$1}')
			# 读取diymode.txt并检查前台应用
			while IFS= read -r line; do
				PKG=$(echo "$line" | awk '{print $1}')
				CUSTOM_MODE=$(echo "$line" | awk '{print $2}')
				if [ "$FG_APP" == "$PKG" ]; then
					MODE="$CUSTOM_MODE"
					break
				fi
			done < "$DIY_MODE_FILE"
		fi

		# 记录当前时间和模式
		Log "当前应用包名: $FG_APP, 当前模式: $MODE"

		Speed_Regulator() {
			case $MODE in
			"powersave")
			    GOVERNOR=("walt" "walt" "walt" "walt" "walt" "walt" "walt" "walt")
                MAX_FREQ=("1574400" "1574400" "2035200" "2035200" "2035200" "2035200" "2035200" "2112000")
                MIN_FREQ=("364000" "364000" "499000" "499000" "499000" "499000" "499000" "499000")
                target_loads=("80 1574400:85" "80 1574400:85" "75 960000:80 1708800:85" "75 960000:80 1708800:85" "75 960000:80 1708800:85" "75 960000:80 1708800:85" "75 960000:80 1708800:85" "75 9024000:80 1708800:85")
                hispeed_freq=("0" "0" "844800" "844800" "844800" "844800" "844800" "787200")
                hispeed_load=("70" "70" "70" "70" "70" "70" "70" "70")
                up_rate_limit_us=("10000" "10000" "10000" "10000" "10000" "10000" "10000" "10000")
                down_rate_limit_us=("0" "0" "0" "0" "0" "0" "0" "0")
                boost=("-20" "-20" "-20" "-20" "-20" "-20" "-20" "-20")
                rtg_boost_freq=("672000" "672000" "614400" "614400" "614400" "614400" "614400" "672000")
                background=("0-6")
                systembackground=("0-6")
                foreground=("0-6")
                topapp=("0-7")
                ;;
            "balance")
                GOVERNOR=("walt" "walt" "walt" "walt" "walt" "walt" "walt" "walt")
                MAX_FREQ=("1574400" "1574400" "2438400" "2438400" "2438400" "2438400" "2438400" "2630400")
                MIN_FREQ=("364000" "364000" "480000" "480000" "480000" "480000" "480000" "499000")
                target_loads=("80" "80" "75 1708800:80 2035200:85" "75 1708800:80 2035200:85" "75 1708800:80 2035200:85" "75 1708800:80 2035200:85" "75 1708800:80 2035200:85" "75 1708800:80 2496000:85")
                hispeed_freq=("0" "0" "1401600" "1401600" "1401600" "1401600" "1401600" "1248000")
                hispeed_load=("80" "80" "70" "70" "70" "70" "70" "70")
                up_rate_limit_us=("4000" "4000" "4000" "4000" "4000" "4000" "4000" "4000")
                down_rate_limit_us=("0" "0" "0" "0" "0" "0" "0" "0")
                boost=("-15" "-15" "-15" "-15" "-15" "-15" "-15" "-15")
                rtg_boost_freq=("0" "0" "844800" "844800" "844800" "844800" "844800" "902400")
                background=("0-4")
                systembackground=("0-4")
                foreground=("0-6")
                topapp=("0-7")
                ;;
            "performance")
                GOVERNOR=("walt" "walt" "walt" "walt" "walt" "walt" "walt" "walt")
                MAX_FREQ=("1804800" "1804800" "2899200" "2899200" "2899200" "2899200" "2899200" "2995200")
                MIN_FREQ=("364000" "364000" "480000" "480000" "480000" "480000" "480000" "499000")
                target_loads=("70 1804800:80" "75 1804800:80" "70 2035200:80 2438400:85" "75 2035200:80 2438400:85" "75 2035200:80 2438400:85" "75 2035200:80 2438400:85" "75 2035200:80 2438400:85" "75 2035200:80 2496000:85")
                hispeed_freq=("0" "0" "1401600" "1401600" "1401600" "1401600" "1401600" "1248000")
                hispeed_load=("65" "65" "70" "70" "70" "70" "70" "70")
                up_rate_limit_us=("2000" "2000" "2000" "2000" "2000" "2000" "2000" "2000")
                down_rate_limit_us=("0" "0" "0" "0" "0" "0" "0" "0")
                boost=("-10" "-10" "-10" "-10" "-10" "-10" "-10" "-10")
                rtg_boost_freq=("0" "0" "844800" "844800" "844800" "844800" "844800" "902400")
                background=("2-3,5-6")
                systembackground=("2-3,5-6")
                foreground=("0-6")
                topapp=("0-7")
                ;;
            "fast")
                GOVERNOR=("walt" "walt" "walt" "walt" "walt" "walt" "walt" "walt")
                MAX_FREQ=("2265600" "2256500" "3148800" "3148800" "3148800" "2956800" "2956800" "3303900")
                MIN_FREQ=("364000" "364000" "480000" "480000" "480000" "480000" "480000" "499000")
                target_loads=("70 2265600:80" "70 2265600:80" "75 2438400:80 2899200:85" "75 2430400:80 2899200:85" "75 2430400:80 2899200:85" "75 2430400:80 2899200:85" "75 2430400:80 2899200:85" "75 2630400:80 3187900:85")
                hispeed_freq=("0" "0" "2035200" "2035200" "2035200" "2035200" "2035200" "1708800")
                hispeed_load=("65" "65" "70" "70" "70" "70" "70" "70")
                up_rate_limit_us=("0" "0" "0" "0" "0" "0" "0" "0")
                down_rate_limit_us=("0" "0" "0" "0" "0" "0" "0" "0")
                boost=("0" "0" "0" "0" "0" "0" "0" "0")
                rtg_boost_freq=("0" "0" "844800" "844800" "844800" "844800" "844800" "902400")
                background=("2-3,5-6")
                systembackground=("2-3,5-6")
                foreground=("0-6")
                topapp=("0-7")
				;;
			*)
				echo "Unknown mode: $MODE"
				exit 1
				;;
			esac
		}

		# 调用Speed_Regulator函数来设置CPU参数
		Speed_Regulator

		# 设置CPU相关文件的权限
		for i in $(seq 0 7); do
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/scaling_min_freq
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/target_loads
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/walt/hispeed_freq
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/hispeed_load
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/up_rate_limit_us
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/down_rate_limit_us
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/boost
		chmod 0755 /sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/rtg_boost_freq
		done
		# 应用CPU设置
		for i in $(seq 0 7); do
			echo ${GOVERNOR[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
			echo ${MAX_FREQ[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq
			echo ${MIN_FREQ[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/scaling_min_freq
			echo ${target_loads[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/target_loads
			echo ${hispeed_freq[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/hispeed_freq
			echo ${hispeed_load[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/hispeed_load
			echo ${up_rate_limit_us[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/up_rate_limit_us
			echo ${down_rate_limit_us[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/down_rate_limit_us
			echo ${boost[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/boost
			echo ${rtg_boost_freq[$i]} >/sys/devices/system/cpu/cpu$i/cpufreq/${GOVERNOR[$i]}/rtg_boost_freq
			echo ${background[$i]} > /dev/cpuset/background/cpus
			echo ${systembackground[$i]} > /dev/cpuset/system-background/cpus
			echo ${foreground[$i]} > /dev/cpuset/foreground/cpus
			echo ${topapp[$i]} > /dev/cpuset/top-app/cpus
		done
	}

	Start
)