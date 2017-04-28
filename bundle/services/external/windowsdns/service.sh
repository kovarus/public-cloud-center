#!/bin/bash

# Other variables
SVCNAME=windowsdns

# source something
# runs in docker container on CCO
. /utils.sh
# add local vars
# used for case below
cmd=$1

downloadService(){
runScript="service2.sh"
scriptFileLocation="/opt/remoteFiles/cliqr_local_file"
curlVar="$customerRepositoryPath/$runScript"
curl -O $curlVar
chmod +x $scriptFileLocation/$runScript
# $scriptFileLocation/$runScript 
}

updateFunction() {
sleep 100
}

getVariables() {
tierName=$cliqrAppTierName
ipParam=CliqrTier_${tierName}_PUBLIC_IP
# echo ${!ipParam}
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
print_log "Downloading addDnsRecord.py"
curl -O http://hq-repo.kpsc.io/kpscservices/external/windowsdns/addDnsRecord.py
print_log "Executing addDnsRecord.py"

print_log "CloudCenter_EXTERNAL_SERVICE_LOG_MSG_START"
print_log "Adding DNS record. "
print_log "CloudCenter_EXTERNAL_SERVICE_LOG_MSG_END"
python ./addDnsRecord.py $hostname ${!ipParam} $dnszone $winrmhost $winrmuser $winrmpassword

print_log "Done adding record."
 
# Add some time to look at the container
sleep 480
}

stopFunction() {
# download script from repo
curl -O http://hq-repo.kpsc.io/kpscservices/external/windowsdns/removeDnsRecord.py
print_log "CloudCenter_EXTERNAL_SERVICE_LOG_MSG_START"
print_log "Removing DNS record. "
print_log "CloudCenter_EXTERNAL_SERVICE_LOG_MSG_END"
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
	    downloadService
	    getVariables
	    installFunction
            startFunction
            echo "[START] Successfully started $SVCNAME"
            ;;
        stop)
            echo "[STOP] Stopping $SVCNAME "
	    downloadService
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
