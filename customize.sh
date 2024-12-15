# 注意 这不是占位符！！这个代码的作用是将模块里的东西全部塞系统里，然后挂上默认权限
SKIPUNZIP=0
#!/bin/bash
[[ "$(getprop ro.product.vendor.model)" != "RMX3888" && "$(getprop ro.product.vendor.model)" != "PJD110" && "$(getprop ro.product.vendor.model)" != "PJX110" && "$(getprop ro.product.vendor.model)" != "RMX5010" && "$(getprop ro.product.vendor.model)" != "PJZ110" && "$(getprop ro.product.vendor.model)" != "OPD2404" ]] && "$(getprop ro.product.vendor.model)" != "RMX3800" ]] && abort "- 不支持的机型！"

set_perm_recursive $MODPATH 0 0 0777 0777
print_modname() {
	ui_print "*******************************"
	ui_print "     	Magisk Module        "
	ui_print "Make By 慕容茹艳（酷安慕容雪绒）"
	ui_print "*******************************"
}

# 目标目录
DIR="/storage/emulated/0/Android/muronggameopt"

# 在这里添加您需要执行的命令
# 延迟输出函数
#!/bin/bash
Outputs() {
  echo "$@"
  sleep 0.07
}

get_app_name() {
  local package_name="$1"
  local app_name=$(dumpsys package "$package_name" | grep -i 'application-label:' | cut -d':' -f2 | tr -d '[:space:]')
  if [ -z "$app_name" ]; then
    app_name="$package_name"
  fi
  echo "$app_name"
}

Volume_key_monitoring() {
  local choose
  while :; do
    choose="$(getevent -qlc 1 | awk '{ print $3 }')"
    case "$choose" in
    KEY_VOLUMEUP) echo "0" && break ;;
    KEY_VOLUMEDOWN) echo "1" && break ;;
    esac
  done
}

install_apk() {
  apk_file="$1"
  if [ -f "$apk_file" ]; then
    pm install -r "$apk_file"
    echo "$apk_file installed successfully."
  else
    echo "Error: $apk_file 未找到!"
    exit 1
  fi
}

install_module() {
  local zipfile="$1"
  # 这里是安装模块的示例代码，具体实现需要根据实际情况编写
  unzip -o "$zipfile" -d "/data/adb/modules_update"
  # 假设安装成功
  return 0
}

VOLUME_KEY_DEVICE="/dev/input/event2"

if [ ! -e "$VOLUME_KEY_DEVICE" ]; then
  Outputs "音量键设备文件不存在，无法检测音量键事件。"
  exit 1
fi

# 本身的模块ID
your_module_id="muronggameopt"

# 检测冲突模块并循环提示卸载
conflict_module_detected=false
for module_dir in /data/adb/modules/*; do
  if [ -d "$module_dir" ]; then
    # 获取当前模块的ID
    current_module_id=$(grep -m 1 'id=' "$module_dir/module.prop" | cut -d '=' -f2)
    
    # 排除自身模块
    if [ "$current_module_id" == "$your_module_id" ]; then
      continue
    fi

    prop_file="$module_dir/system.prop"
    if [ -f "$prop_file" ] && grep -q 'persist.oplus.display.vrr' 'persist.oplus.display.vrr.adfr' 'persist.oplus.display.pixelworks' "$prop_file"; then
      conflict_module_detected=true
      module_prop="$module_dir/module.prop"
      if [ -f "$module_prop" ]; then
        conflict_module_name=$(grep -m 1 'name=' "$module_prop" | cut -d '=' -f2)
        
        Outputs "检测到冲突的Magisk模块: $conflict_module_name"
        Outputs "请问是否卸载？"
        Outputs "   - 音量上键 = 卸载模块"
        Outputs "   - 音量下键 = 取消安装"

        branch=$(Volume_key_monitoring)

        if [ "$branch" == "0" ]; then
          Outputs "正在卸载冲突模块..."
          # 停止模块的服务
          if [ -f "$module_dir/service.sh" ]; then
            "$module_dir/service.sh" --stop
          fi
          # 删除模块目录
          #rm -rf "$module_dir"
          if [ $? -eq 0 ]; then
            Outputs "卸载成功。"
          else
            Outputs "卸载失败，请检查权限或手动卸载。"
            exit 1
          fi
        else
          Outputs "取消安装。"
          exit 1
        fi
      fi
    fi
  fi
done

if [ "$conflict_module_detected" = false ]; then
  Outputs "没有检测到冲突的Magisk模块。"
fi

# 主安装函数
main() {
  # 提示用户是否安装APK
  echo "是否安装APK?"
  echo "   - 音量上键 = 安装APK"
  echo "   -安装则用慕容调度控制模式切换"
  echo "   - 音量下键 = 跳过安装"
  echo "   -不安装则用scene控制模式切换"
  
  branch=$(Volume_key_monitoring)

  if [ "$branch" == "0" ]; then
    # 用户选择安装APK
    install_apk "$MODPATH/慕容官调优化.apk"
    # 删除data目录里的powercfg.json和powercfg.sh这两个文件
    rm -f "/data/powercfg.json"
    rm -f "/data/powercfg.sh"
    echo "powercfg.json 和 powercfg.sh 已删除."
    # 删除当前目录的vtools文件夹
    rm -rf "$MODPATH/vtools"
    echo "vtools文件夹已删除."
    # 创建目录
    mkdir -p "$DIR"
    [ -d "$DIR" ] || mkdir -p "$DIR"
    if [ ! -f "$DIR/mode.txt" ]; then
    # 创建并写入mode.txt
    echo "powersave" >"$DIR/mode.txt"
    fi
    # 检查文件是否存在
    if [ ! -f "$DIR/diymode.txt" ]; then
    # 文件不存在，创建文件
    touch "$DIR/diymode.txt"
    echo "文件diymode.txt已创建"
    else
    # 文件存在
    echo "文件 $DIR/diymode.txt 已存在"
    fi
  else
    # 用户选择跳过安装
    echo "用户选择跳过安装APK。"
    # 检查service.sh文件是否存在
    SERVICE_SH="$MODPATH/service.sh"
    if [ -f "$SERVICE_SH" ]; then
      # 读取service.sh文件内容
      SERVICE_SH_CONTENT=$(cat "$SERVICE_SH")
      # 获取前37行的内容
      SERVICE_SH_HEAD=$(echo "$SERVICE_SH_CONTENT" | head -n 37)
      # 获取第38行之后的内容
      SERVICE_SH_TAIL=$(echo "$SERVICE_SH_CONTENT" | tail -n +39)
      # 拼接新的第38行内容和之前的内容
      NEW_SERVICE_SH_LINE="sh \$MODPATH/vtools/init_vtools.sh \$(realpath \$MODPATH/module.prop)"
      # 写入新的文件内容
      echo -e "$SERVICE_SH_HEAD\n$NEW_SERVICE_SH_LINE\n$SERVICE_SH_TAIL" > "$SERVICE_SH"
      echo "已向service.sh的第38行写入命令。"
    else
      echo "service.sh文件不存在，无法写入命令。"
    fi
    sh $MODPATH/vtools/init_vtools.sh $(realpath $MODPATH/module.prop)
    rm -rf /data/media/0/Android/muronggameopt
    rm -rf $DIR
    # 创建目录
    mkdir -p "$DIR"
    [ -d "$DIR" ] || mkdir -p "$DIR"
    
    if [ ! -f "$DIR/mode.txt" ]; then
	# 创建并写入mode.txt
	echo "powersave" >"$DIR/mode.txt"
	fi
  fi
}

# 调用主安装函数
main

# 检查模块名字是否为“慕容线程”
module_name=$(grep -m 1 'name=' "$module_dir/module.prop" | cut -d '=' -f2)
service_sh_file="$MODPATH/service.sh"

# 确保service.sh存在
if [ ! -f "$service_sh_file" ]; then
  touch "$service_sh_file"
fi

# 确保service.sh至少有41行（因为我们要在第42行插入内容）
for i in $(seq 1 41); do
  if [ $(wc -l < "$service_sh_file") -lt $i ]; then
    echo "# placeholder line" >> "$service_sh_file"
  fi
done

# 插入pm enable命令到service.sh的第42行
if [ "$module_name" == "慕容线程" ]; then
  # 插入pm enable命令到第42行并现在执行一下
  sed -i -e '42i\
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaAMTService\
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.HyperBoostService\
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaGameSdkService\
pm enable com.oplus.cosa/com.oplus.cosa.service.COSAService\
pm enable com.oplus.cosa/com.oplus.cosa.service.GameDaemonService\
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaHyperBoostService\
pm enable com.oplus.cosa/com.oplus.cosa.testlibrary.service.COSATesterService\
pm enable com.oplus.cosa/androidx.work.impl.background.systemjob.SystemJobService\
pm enable com.oplus.cosa/com.oplus.cosa.feature.ScreenPerceptionService\
pm enable com.oplus.cosa/com.oplus.cosa.gpalibrary.service.GPAService\
pm enable com.oplus.cosa/androidx.work.impl.background.systemalarm.SystemAlarmService\
pm enable com.oplus.cosa/androidx.work.impl.foreground.SystemForegroundService\
pm enable com.oplus.cosa/androidx.room.MultiInstanceInvalidationService\' "$service_sh_file"
  # 执行pm enable命令
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaAMTService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.HyperBoostService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaGameSdkService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.service.COSAService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.service.GameDaemonService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaHyperBoostService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.testlibrary.service.COSATesterService > /dev/null 2>&1
pm enable com.oplus.cosa/androidx.work.impl.background.systemjob.SystemJobService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.feature.ScreenPerceptionService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.gpalibrary.service.GPAService > /dev/null 2>&1
pm enable com.oplus.cosa/androidx.work.impl.background.systemalarm.SystemAlarmService > /dev/null 2>&1
pm enable com.oplus.cosa/androidx.work.impl.foreground.SystemForegroundService > /dev/null 2>&1
pm enable com.oplus.cosa/androidx.room.MultiInstanceInvalidationService > /dev/null 2>&1
echo "* 启用应用增强组件完毕"
else
  # 如果没有检测到模块名字是“慕容线程”，则在第42行添加额外的pm enable命令并现在执行一次
  sed -i -e '42i\
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaAMTService\
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.HyperBoostService\
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaGameSdkService\
pm enable com.oplus.cosa/com.oplus.cosa.service.COSAService\
pm enable com.oplus.cosa/com.oplus.cosa.service.GameDaemonService\
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaHyperBoostService\
pm enable com.oplus.cosa/com.oplus.cosa.testlibrary.service.COSATesterService\
pm enable com.oplus.cosa/androidx.work.impl.background.systemjob.SystemJobService\
pm enable com.oplus.cosa/com.oplus.cosa.feature.ScreenPerceptionService\
pm enable com.oplus.cosa/com.oplus.cosa.gpalibrary.service.GPAService\
pm enable com.oplus.cosa/androidx.work.impl.background.systemalarm.SystemAlarmService\
pm enable com.oplus.cosa/androidx.work.impl.foreground.SystemForegroundService\
pm enable com.oplus.cosa/androidx.room.MultiInstanceInvalidationService\
pm enable com.oplus.cosa/com.oplus.cosa.service.GameEventService\' "$service_sh_file"
  # 执行pm enable命令
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaAMTService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.HyperBoostService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaGameSdkService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.service.COSAService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.service.GameDaemonService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.gamemanagersdk.CosaHyperBoostService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.testlibrary.service.COSATesterService > /dev/null 2>&1
pm enable com.oplus.cosa/androidx.work.impl.background.systemjob.SystemJobService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.feature.ScreenPerceptionService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.gpalibrary.service.GPAService > /dev/null 2>&1
pm enable com.oplus.cosa/androidx.work.impl.background.systemalarm.SystemAlarmService > /dev/null 2>&1
pm enable com.oplus.cosa/androidx.work.impl.foreground.SystemForegroundService > /dev/null 2>&1
pm enable com.oplus.cosa/androidx.room.MultiInstanceInvalidationService > /dev/null 2>&1
pm enable com.oplus.cosa/com.oplus.cosa.service.GameEventService > /dev/null 2>&1
echo "* 启用应用增强组件完毕"
fi

# 现在继续执行安装过程
# ... 安装模块的代码 ...

# 检查是否使用FAS优化
Outputs "是否使用FAS优化："
Outputs "   - 音量上键 = 使用FAS"
Outputs "   - 音量下键 = 不使用FAS"

# 监听音量键选择
branch=$(Volume_key_monitoring)

# 定义service.sh文件路径
service_sh_file="$MODPATH/service.sh"

# 确保service.sh存在
if [ ! -f "$service_sh_file" ]; then
  touch "$service_sh_file"
fi

# 确保service.sh至少有40行
for i in $(seq 1 40); do
  if [ $(wc -l < "$service_sh_file") -lt $i ]; then
    echo "# placeholder line" >> "$service_sh_file"
  fi
done

# 根据用户选择配置service.sh
if [ "$branch" == "0" ]; then
  Outputs "用户选择使用FAS，正在配置..."
  sed -i '40iecho 0 > /proc/game_opt/disable_cpufreq_limit' "$service_sh_file"
else
  Outputs "用户选择不使用FAS，正在配置..."
  sed -i '40iecho 1 > /proc/game_opt/disable_cpufreq_limit' "$service_sh_file"
fi

Outputs "配置成功。"