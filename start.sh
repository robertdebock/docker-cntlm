#!/bin/sh

# All values are written to /etc/cntlm.conf and also displayed for ease of use.
# (Passwords are not displayed).

echo "Username ${USERNAME}" | tee /etc/cntlm.conf

if [ "${PASSWORD}" != "UNSET" ] ; then
  echo "Password ${PASSWORD}" >> /etc/cntlm.conf
  echo "Password -HIDDEN-"
fi

echo "Domain ${DOMAIN}" | tee -a /etc/cntlm.conf

if [ "${PROXY}" ] ; then
  for i in $(echo ${PROXY} | sed "s/;/ /g")
  do
      echo "Proxy ${i}" | tee -a /etc/cntlm.conf
      echo "Setting Proxy ${i}"
  done
else
  echo "No proxy defined! Please set it using the variable \"PROXY\"."
  exit 1
fi

echo "Listen ${LISTEN}" | tee -a /etc/cntlm.conf

if [ "${AUTH}" != "UNSET" ] ; then
  echo "Auth ${AUTH}" | tee -a /etc/cntlm.conf
fi

if [ "${PASSLM}" != "UNSET" ] ; then
  echo "PassLM ${PASSLM}" | tee -a /etc/cntlm.conf
fi

if [ "${PASSNT}" != "UNSET" ] ; then
  echo "PassNT ${PASSNT}" | tee -a /etc/cntlm.conf
fi

if [ "${PASSNTLMV2}" != "UNSET" ] ; then
  echo "PassNTLMv2 ${PASSNTLMV2}" | tee -a /etc/cntlm.conf
fi

if [ "${NOPROXY}" != "UNSET" ] ; then
  echo "NoProxy ${NOPROXY}" | tee -a /etc/cntlm.conf
fi

# Start cntlm after all configuration has been written.
/usr/sbin/cntlm -c /etc/cntlm.conf -f ${OPTIONS}
