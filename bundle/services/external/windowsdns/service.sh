#!/bin/bash

# Other variables
SVCNAME=windowsdns

# source something
# runs in docker container on CCO
. /utils.sh
# add local vars
cmd=$1

updateFunction() {
sleep 100
}
getVariables() {
tierName=$cliqrAppTierName
 
ipParam=CliqrTier_${tierName}_PUBLIC_IP
echo ${!ipParam}
}

installFunction(){
# install packages
yum install -y epel-release
yum install -y python-pip
pip install pywinrm
pip install --upgrade pip
}

startFunction() {
# Download script from repo
# curlUrl="$customerRepositoryPath/addDnsRecord.py"
# curl -O $curlUrl
curl -O http://hq-repo.kpsc.io/kpscservices/external/windowsdns/addDnsRecord.py
# set some temp variables
# hostname="test-"$currentTierJobId
# ipaddress="10.16.0.123"
# dnszone="corp.local"
# winrmhost="winrm.corp.local"
# winrmuser="svc.winrm@corp.local"
# winrmpassword="changeMe"
print_log "Executing addDnsRecord.py"

echo "CloudCenter_EXTERNAL_SERVICE_LOG_MSG_START"
echo "Adding DNS record. "
echo "CloudCenter_EXTERNAL_SERVICE_LOG_MSG_END"
python ./addDnsRecord.py $hostname ${!ipParam} $dnszone $winrmhost $winrmuser $winrmpassword

print_log "Done adding record."
 
# Add some time to look at the container
sleep 480
}

stopFunction() {
# download script from repo
curl -O http://hq-repo.kpsc.io/kpscservices/external/windowsdns/removeDnsRecord.py
# curlUrl="$customerRepositoryPath/removeDnsRecord.py"
# curl -O $curlUrl

# hostname="test-"$currentTierJobId
# ipaddress="10.16.0.123"
# dnszone="corp.local"
# winrmhost="winrm.corp.local"
# winrmuser="svc.winrm@corp.local"
# winrmpassword="changeMe"
echo "CloudCenter_EXTERNAL_SERVICE_LOG_MSG_START"
echo "Removing DNS record. "
echo "CloudCenter_EXTERNAL_SERVICE_LOG_MSG_END"
python ./removeDnsRecord.py $cliqrNodeHostname ${!ipParam} $dnszone $winrmhost $winrmuser $winrmpassword

print_log "Done removing record."

# Add some time to look at the container
sleep 480
}

suspendFunction() {
sleep 100
}

resumeFunction() {
sleep 100
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
	    getVariables
	    installFunction
            startFunction
            echo "[START] Successfully started $SVCNAME"
            ;;
        stop)
            echo "[STOP] Stopping $SVCNAME "
	    getVariables
	    installFunction
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
