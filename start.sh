#!/bin/sh

# All values are written to /etc/cntlm.conf and also displayed for ease of use.
# (Passwords are not displayed).

if [[ -z "${CUSTOM_CONFIG}" ]]; then
  # No custom config. Add all information.

  if [[ -z "${USERNAME}" ]]; then
    echo "USERNAME not defined."
    exit 1
  else
    echo "Username ${USERNAME}" | tee /etc/cntlm.conf
  fi

  if [[ -z "${DOMAIN}" ]]; then
    echo "DOMAIN not defined."
    exit 1
  else
    echo "Domain ${DOMAIN}" | tee -a /etc/cntlm.conf
  fi

  if ! [[ -z "${PASSWORD}" ]]; then
    echo "Password ${PASSWORD}" >> /etc/cntlm.conf
    echo "Password -HIDDEN-"
  fi

  if [[ -z "${PROXY}" ]]; then
    echo "PROXY not defined."
    exit 1
  else
    for i in $(echo ${PROXY} | sed "s/;/ /g")
    do
        echo "Proxy ${i}" | tee -a /etc/cntlm.conf
    done
  fi

  if [[ -z "${NOPROXY}" ]]; then
    NOPROXY='localhost, 127.0.0.*, 10.*, 192.168.*'
  fi

  echo "NoProxy ${NOPROXY}" | tee -a /etc/cntlm.conf

  if [[ -z "${LISTEN}" ]]; then
    LISTEN='0.0.0.0:3128'
  fi

  echo "Listen ${LISTEN}" | tee -a /etc/cntlm.conf

  if ! [[ -z "${AUTH}" ]]; then
    echo "Auth ${AUTH}" | tee -a /etc/cntlm.conf
  fi

  if ! [[ -z "${PASSLM}" ]]; then
    echo "PassLM ${PASSLM}" | tee -a /etc/cntlm.conf
  fi

  if ! [[ -z "${PASSNT}" ]]; then
    echo "PassNT ${PASSNT}" | tee -a /etc/cntlm.conf
  fi

  if ! [[ -z "${PASSNTLMV2}" ]]; then
    echo "PassNTLMv2 ${PASSNTLMV2}" | tee -a /etc/cntlm.conf
  fi
else
  # Custom config will be mounted. Skip everything.
  echo "Custom config will be used. Skipping all custom settings."
fi

# first arg is `-H` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- /usr/sbin/cntlm -c /etc/cntlm.conf "$@"
else
  set -- /usr/sbin/cntlm -c /etc/cntlm.conf -f ${OPTIONS}
fi

exec "$@"