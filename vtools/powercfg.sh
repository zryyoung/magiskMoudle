#system/bin/sh
mode=/data/media/0/Android/muronggameopt/mode.txt

case "$1" in
"powersave" | "standby") echo powersave >$mode ;;
"balance") echo balance >$mode ;;
"performance") echo performance >$mode ;;
"init" | "fast" | "pedestal") echo fast >$mode ;;
esac