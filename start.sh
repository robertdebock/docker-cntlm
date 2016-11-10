#!/bin/sh

echo "Username ${USERNAME}" | tee /etc/cntlm.conf

if [ ${PASSWORD} != "UNSET" ] ; then
  echo "Password ${PASSWORD}" >> /etc/cntlm.conf
  echo "Password -HIDDEN-"
fi

echo "Domain ${DOMAIN}" | tee -a /etc/cntlm.conf

if [ ${PROXIES} ] ; then
  for PROXY in ${PROXIES} ; do 
    echo "Proxy ${PROXY}" | tee -a /etc/cntlm.conf
  done
elif [ ${PROXY} ] ; then
  echo "Proxy ${PROXY}" | tee -a /etc/cntlm.conf
else
  echo "No proxy defined!"
  exit 1
fi

echo "Listen ${LISTEN}" | tee -a /etc/cntlm.conf

if [ ${PASSLM} != "UNSET" ] ; then
  echo "PassLM ${PASSLM}" | tee -a /etc/cntlm.conf
fi

if [ ${PASSNT} != "UNSET" ] ; then
  echo "PassNT ${PASSNT}" | tee -a /etc/cntlm.conf
fi

if [ ${PASSNTLMV2} != "UNSET" ] ; then
  echo "PassNTLMv2 ${PASSNTLMV2}" | tee -a /etc/cntlm.conf
fi

/usr/sbin/cntlm -c /etc/cntlm.conf -f -v
