#!/usr/bin/env bash
# 
# Wait for Liferay to startup and execute command
# https://docs.docker.com/compose/startup-order/
#

CMDNAME=${0##*/}

echoerr() { if [[ $QUIET -ne 1 ]]; then echo "$@" 1>&2; fi }

usage() {
  exitcode="$1"
  cat << USAGE >&2
Usage:
  $CMDNAME host:port [-- command args]
  -q | --quiet                        Don't output any status messages
  -- COMMAND ARGS                     Execute command with args after the test finishes
USAGE
  exit "$exitcode"
}

wait_for_liferay() {
  until curl -fsS "$HOST:$PORT/c/portal/layout"; do
    echoerr "Liferay is unavailable on $HOST:$PORT - sleeping"
    sleep 1
  done
  echoerr "Liferay is up on $HOST:$PORT - executing command"
  exec "$@"
}

while [ $# -gt 0 ]
do
  case "$1" in
    *:* )
    HOSTPORT=(${1//:/ })
    HOST=${HOSTPORT[0]}
    PORT=${HOSTPORT[1]}
    shift 1
    ;;
    -q | --quiet)
    QUIET=1
    shift 1
    ;;
    --)
    shift
    break
    ;;
    *)
    echoerr "Unknown argument: $1"
    usage 1
    ;;
  esac
done

if [ "$HOST" = "" -o "$PORT" = "" ]; then
  echoerr "Error: you need to provide a host and port to test."
  usage 2
fi

wait_for_liferay "$@"