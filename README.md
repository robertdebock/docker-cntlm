# docker-cntlm
A container to function as a proxy, based on [Cntlm](http://cntlm.sourceforge.net). Other containers can link to this one for their web access. This container authenticates to an external proxy and can be used by other containers without authentication details.

## Generating a password hash
A password hash needs te be generated once, after which is can be used when running the proxy.

    docker run \
      -e "PASSWORD=mypassword" \
      robertdebock/docker-cntlm \
      /usr/sbin/cntlm -H \
      -u username \
      -d mydomain

You'll seen output like this:

    Password: 
    PassLM          1AD35398BE6565DDB5C4EF70C0593492
    PassNT          77B9081511704EE852F94227CF48A793
    PassNTLMv2      640937B847F8C6439D87155508FA8479    # Only for user 'username', domain 'mydomain'

That PassNTLMv2 hash (640937B847F8C6439D87155508FA8479 in this example) is required to run the proxy.

## Running the proxy
To run the proxy:
- you'll need the PASSNTLMV2 hash generated in the step before.
- you'll also need the proxy to send traffic to.

This is an example of how to run this container.
 
    docker run \
    -e "USERNAME=username" \
    -e "DOMAIN=mydomain" \
    -e "PASSNTLMV2=640937B847F8C6439D87155508FA8479" \
    -e "PROXY=123.123.123.123:8080" \
    robertdebock/docker-cntlm

Other settings you might want to use are:
||Variable||Description||
|LISTEN|The IP/hostname and port (separated by a colon) to listen to. I.e. "127.0.0.1:8080"|
|PASSNTLMV2|Required for auth method Auth NTLMv2.|
|PASSNT|Required for auth method Auth NTLM2SR, Auth NT and Auth NTLM.|
|PASSLM|Required for auth method Auth LM and Auth NTLM.|

Find [technical details here](http://cntlm.sourceforge.net/cntlm_manual.pdf).
