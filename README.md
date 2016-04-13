# docker-cntlm
A container to function as a proxy. Other containers can link to this one for their web access. This container authenticates to an external proxy and can be used by other containers without authentication details.

## Generating a password hash
A password hash needs te be generated once, after which is can be used when running the proxy.

    docker run \
      -e "PASSWORD=mypassword" \
      robertdebock/docker-cntlm \
      /usr/sbin/cntlm -H \
      -u username \
      -d mydomain

You'll seen output like this:

    docker run -e "PASSWORD=mypassword" robertdebock/docker-cntlm /usr/sbin/cntlm -H -u username -d mydomain
    Password: 
    PassLM          1AD35398BE6565DDB5C4EF70C0593492
    PassNT          77B9081511704EE852F94227CF48A793
    PassNTLMv2      640937B847F8C6439D87155508FA8479    # Only for user 'username', domain 'mydomain'

That PassNTLMv2 hash (640937B847F8C6439D87155508FA8479 in this example) is required to run the proxy.

## Running the proxy
To run the proxy, run this command. (You'll need the PASSNTLMV2 hash generated in the step before.)
 
    docker run \
    -e "USERNAME=username" \
    -e "DOMAIN=mydomain" \
    -e "PASSNTLMV2=640937B847F8C6439D87155508FA8479" \
    robertdebock/docker-cntlm
