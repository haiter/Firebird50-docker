#!/usr/bin/env bash
set -e


RunUser=firebird
export RunUser
RunGroup=firebird
export RunGroup
PidDir=/var/run/firebird
export PidDir

#------------------------------------------------------------------------
# Get correct options & misc.

psOptions=-efaww
export psOptions
mktOptions=-q
export mktOptions
tarOptions=z
export tarOptions
tarExt=tar.gz
export tarExt


PATH="${PATH}:${PREFIX}/bin"

build() {
    local var="$1"
    local stmt="$2"
    export "$var"+="$(printf "\n%s" "${stmt}")"
}

confSet() {
    confFile="${PREFIX}/firebird.conf"
    # Uncomment specified value
    sed -i "s/^#${1}/${1}/g" "${confFile}"
    # Set Value to new value
    sed -i "s~^\(${1}\s*=\s*\).*$~\1${2}~" "${confFile}"
}

confSetDB() {
    confFile="${PREFIX}/databases.conf"
    # Uncomment specified value
    sed -i "s/^#${1}/${1}/g" "${confFile}"
    # Set Value to new value
    sed -i "s~^\(${1}\s*=\s*\).*$~\1${2}~" "${confFile}"
}


#



firebirdSetup(){
# Create any missing folders
  mkdir -p "${VOLUME}/system"
  mkdir -p "${VOLUME}/log"
  mkdir -p "${VOLUME}/data"
  mkdir -p "${VOLUME}/etc"
  

  confSet RemoteServiceName  "gds_db"
  confSet RemoteServicePort  "3050"
  confSet ServerMode  "Super"
  confSet SecurityDatabase ${VOLUME}/system/security5.fdb
  confSetDB security.db ${VOLUME}/system/security5.fdb
   
  

 

  if [[ ! -e "${VOLUME}/etc/firebird.conf" ]]; then
      
      cp  "${PREFIX}/databases.conf" "${VOLUME}/etc/"
      cp  "${PREFIX}/firebird.conf" "${VOLUME}/etc/"
      cp  "${PREFIX}/fbtrace.conf" "${VOLUME}/etc/"
      cp  "${PREFIX}/plugins.conf" "${VOLUME}/etc/"
      cp  "${PREFIX}/replication.conf" "${VOLUME}/etc/"
      cp  "${PREFIX}/SYSDBA.password" "${VOLUME}/etc/"
      cp  "${PREFIX}/replication.log" "${VOLUME}/log/"
      cp  "${PREFIX}/firebird.log" "${VOLUME}/log/"
      cp  "${PREFIX}/skel/security5.fdb" "${VOLUME}/system/"
            
 else
    
    cp  "${VOLUME}/etc/databases.conf" "${PREFIX}/"
    cp  "${VOLUME}/etc/firebird.conf" "${PREFIX}/"
    cp  "${VOLUME}/etc/fbtrace.conf" "${PREFIX}/"
    cp  "${VOLUME}/etc/plugins.conf" "${PREFIX}/"
    cp  "${VOLUME}/etc/replication.conf" "${PREFIX}/"
    
fi
  

}


if [[ "$1" == "firebird" ]]; then

  rcfirebird shutdown

  firebirdSetup

  trap 'kill -TERM "$FBPID"' SIGTERM

     /opt/firebird/bin/fbguard &

    FBPID=$!
    
    wait "$FBPID"
  
fi

exec "$@"