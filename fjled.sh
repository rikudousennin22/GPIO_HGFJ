#!/bin/bash

# Internet Indicator for B860H v1/v2 Wrapper
# by Lutfa Ilham
# v1.0
# GPIO Founder RIKUDO

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

SERVICE_NAME="Internet Indicator"

function loop() {
  while true; do
        fjledon -lan dis
        fjledon -led1 off
	fjledon -remote_led on
    if curl -X "HEAD" --connect-timeout 3 -so /dev/null "http://bing.com"; then
      fjledon -lan on
      fjledon -led1 on
      fjledon -remote_led off
    else
      fjledon -lan off
      fjledon -led1 off
      fjledon -remote_led on
    fi
    sleep 1
  done 
}

function start() {
  echo -e "Starting ${SERVICE_NAME} service ..."
  screen -AmdS internet-indicator "${0}" -l
}

function stop() {
  echo -e "Stopping ${SERVICE_NAME} service ..."
  kill $(screen -list | grep internet-indicator | awk -F '[.]' {'print $1'})
}

function usage() {
  cat <<EOF
Usage:
  -r  Run ${SERVICE_NAME} service
  -s  Stop ${SERVICE_NAME} service
EOF
}

case "${1}" in
  -l)
    loop
    ;;
  -r)
    start
    ;;
  -s)
    stop
    ;;
  *)
    usage
    ;;
esac
