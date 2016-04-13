# docker-cntlm
A container to function as a proxy. Other containers can link to this one for their web access. This container authenticates to an external proxy and can be used by other containers without authentication details.

## Generating a password hash
A password hash needs te be generated once, after which is can be used when running the proxy.

    docker run -e "PASSWORD=mypassword" robertdebock/docker-cntlm /usr/sbin/cntlm -H -u username -d mydomain

## Running the proxy
 
