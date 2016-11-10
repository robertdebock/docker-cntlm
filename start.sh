#!/bin/sh

echo "Preparing a proxy on ${LISTEN}, connecting to ${PROXY}. (Username: ${USERNAME}, domain: ${DOMAIN})"

echo "Username ${USERNAME}" > /etc/cntlm.conf

if [ ${PASSWORD} != "UNSET" ] ; then
  echo "Password ${PASSWORD}" >> /etc/cntlm.conf
fi

echo "Domain ${DOMAIN}" >> /etc/cntlm.conf

if [ ${PROXIES} ] ; then
  for PROXY in ${PROXIES} ; do 
    echo "Proxy ${PROXY}" >> /etc/cntlm.conf
  done
elif [ ${PROXY} ] ; then
  echo "Proxy ${PROXY}" >> /etc/cntlm.conf
else
  echo "No proxy defined!"
  exit 1
fi

echo "Listen ${LISTEN}" >> /etc/cntlm.conf

if [ ${PASSLM} != "UNSET" ] ; then
  echo "PassLM ${PASSLM}" >> /etc/cntlm.conf
fi

if [ ${PASSNT} != "UNSET" ] ; then
  echo "PassNT ${PASSNT}" >> /etc/cntlm.conf
fi

if [ ${PASSNTLMV2} != "UNSET" ] ; then
  echo "PassNTLMv2 ${PASSNTLMV2}" >> /etc/cntlm.conf
fi

/usr/sbin/cntlm -c /etc/cntlm.conf -f -v
