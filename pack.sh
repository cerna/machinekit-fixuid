#!/bin/sh
cd $(dirname $0)

display_usage() {
    echo "Usage:\n$0 [version]"
}

# check whether user had supplied -h or --help . If yes display usage
if [ $# = "--help" ] || [ $# = "-h" ]
then
    display_usage
    exit 0
fi

# check number of arguments
if [ $# -ne 1 ]
then
    display_usage
    exit 1
fi

for GOOS in linux; do
    for GOARCH in amd64 arm64 arm 386; do
        export GOOS="$GOOS"
        export GOARCH="$GOARCH"
        if [ "$GOARCH" = "386" ]
        then
            DEB_ARCH="i386"
        elif [ "$GOARCH" = "arm" ]
        then
            DEB_ARCH="armhf"
        else
            DEB_ARCH="$GOARCH"
        fi
        ./build.sh
        rm -f machinekit-fixuid-*-${DEB_ARCH}.tar.gz
        perm="$(id -u):$(id -g)"
        sudo chown root:root fixuid
        sudo chmod u+s fixuid
        tar -cvzf machinekit-fixuid-${DEB_ARCH}.tar.gz fixuid
        sudo chmod u-s fixuid
        sudo chown $perm fixuid
    done
done
