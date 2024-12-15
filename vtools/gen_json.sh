propPath=$1
version=$(cat $propPath | grep "version=" | cut -d "=" -f2)

json=$(
	cat <<EOF
{
    "name": "ColorOS官调优化",
    "author": "慕容茹艳（酷安慕容雪绒）",
    "version": "$version",
    "versionCode": 202412151606,
    "features": {
        "strict": true,
        "pedestal": true
    },
    "module": "muronggameopt",
    "state": "/data/media/0/Android/muronggameopt/mode.txt",
    "entry": "/data/powercfg.sh"
}
EOF
)
