#!/bin/sh -x

# See if we've received a variable USERNAME.
if [ ! ${USERNAME} -o ! ${PASSWORD} -o ! ${DOMAIN} ] ; then
  echo "Please set the variables USERNAME, PASSWORD and DOMAIN."
  exit 1
fi

# Set the variables in /etc/cntlm.conf
cat << EOF > /etc/cntlm.conf
Username ${USERNAME}
Password ${PASSWORD}
Domain ${DOMAIN}
EOF

# Run cntlm to generate hashes.
cntlm -H
