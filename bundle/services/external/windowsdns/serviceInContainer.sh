#!/bin/bash

# Other variables
SVCNAME=windowsdns

# source something
# runs in docker container on CCO
# . /root/docker/cliqr-container-worker/utils.sh
# add local vars
cmd=$1

updateFunction() {
sleep 10000
}

startFunction() {
# install packages
yum install -y epel-release
yum install -y python-pip
pip install pywinrm
pip install --upgrade pip
curl -O http://hq-repo.kpsc.io/kpscservices/external/windowsdns/addDnsRecord.py
# set some temp variables
hostname="test-"$currentTierJobId
ipaddress="10.16.0.123"
dnszone="kpsc.io"
winrmhost="hq-dc1.kpsc.io"
winrmuser="svc.winrm@kpsc.io"
winrmpassword="!Passw0rd"
python ./addDnsRecord.py $hostname $ipaddress $dnszone $winrmhost $winrmuser $winrmpassword


sleep 10000
}

stopFunction() {
sleep 10000
}

suspendFunction() {
sleep 10000
}

resumeFunction() {
sleep 10000
}

# place holders

    case $cmd in
        update)
            echo "[UPDATE] Update $SVCNAME "
            updateFunction
            echo "[UPDATE] Successfully updated $SVCNAME"
            ;;
        start)
            echo "[START] Starting $SVCNAME "
            startFunction
            echo "[START] Successfully started $SVCNAME"
            ;;
        stop)
            echo "[STOP] Stopping $SVCNAME "
            stopFunction
            echo "[STOP] Successfully stopped $SVCNAME"
	           ;;
        suspend)
            echo "[SUSPEND] Suspending $SVCHOME"
            suspendFunction
            echo "[SUSPEND] Successfully suspended $SVCNAME"
            ;;
        resume)
            echo "[RESUME] Resuming $SVCHOME"
            resumeFunction
            echo "[RESUME] Successfully resumed s$SVCNAME"
            ;;
    esac
