# docker-cntlm

[![build-push](https://github.com/robertdebock/docker-cntlm/actions/workflows/build-push-action.yml/badge.svg)](https://github.com/robertdebock/docker-cntlm/actions/workflows/build-push-action.yml)

A container to function as a proxy, based on [CNTLM](http://cntlm.sourceforge.net). Other systemc can connect to this proxy for their web access. This container authenticates to an external proxy and can be used by others without authentication details.

```text
              +- - - - - - -+  +- - - - - - - - -+
              | no password |  | password (hash) |
              +- - - - - - -+  +- - - - - - - - -+
                      |              |
+------------------+  V   +-------+  V   +-----------------+      +----------+
| your workstation | ---> | cntlm | ---> | corporate proxy | ---> | internet |
+------------------+      +-------+      +-----------------+      +----------+
```

## Generating a password hash

A password hash needs te be generated once, after which is can be used when running the proxy.

```console
docker run \
  -e "USERNAME=my_username" \
  -e "DOMAIN=example.com" \
  -e "PROXY=proxy.example.com:3128" \
  --rm -it robertdebock/docker-cntlm -H
```

Now you have to enter your password (which will not be displayed) and press enter.

Replace:

- `my_username` for your own username.
- `example.com` for you own domain.

> The `PROXY` variable can have any value when generating a hash. For running CNTLM, a correct value is required.

You'll seen output like this:

```text
    Password: 
    PassLM          1AD35398BE6565DDB5C4EF70C0593492
    PassNT          77B9081511704EE852F94227CF48A793
    PassNTLMv2      640937B847F8C6439D87155508FA8479    # Only for user 'username', domain 'mydomain'
```

## Running the proxy

To run the proxy:

- you'll need the PASSNTLMV2 hash generated in the step before.
- you'll also need the proxy to send traffic to.

This is an example of how to run this container.

``` console
docker run --restart always --name cntlm \
  -e "USERNAME=my_username" \
  -e "DOMAIN=example.com" \
  -e "PASSNTLMV2=MY_HASH_MY_HASH_MY_HASH_MY_HASH_" \
  -e "PROXY=proxy.example.com:3128" \
  -p 3128:3128 \
  robertdebock/docker-cntlm
```

# Required variabled.

|VARIABLE    |EXAMPLE                           |DESCRIPTION                                  |
|------------|----------------------------------|---------------------------------------------|
|`USERNAME`  |`my_username`                     |Your username, without a domain (`@` or `\`).|
|`DOMAIN`    |`example.com`                     |The domain where your user lives.            |
|`PASSNTLMV2`|`640937B847F8C6439D87155508FA8479`|The generated hash, see above.               |
|`PROXY` *   |`proxy.example.com`               |The hostname (or IP) of your corporate proxy.|

* = `PROXY` can be a string (single) or a list (mulitple). For example: `example.com:3128;example.com:3129`.

> The `-p 3138:3128` maps the port on a host (left from colon) to a port on the container (right from colon).

# Optional variables


|VARIABLE     |EXAMPLE          |DESCRIPTION                                                                    |
|-------------|-----------------|-------------------------------------------------------------------------------|
|LISTEN       |`127.0.0.1:8080` |The IP/hostname and port (separated by a colon) to listen to.                  |
|AUTH         |                 |Auth parameter.                                                                |
|PASSNT       |                 |Required for auth method Auth NTLM2SR, Auth NT and Auth NTLM.                  |
|PASSLM       |                 |equired for auth method Auth LM and Auth NTLM.                                 |
|NOPROXY      |`127.0.0.1, 10.*`|For address which should not be routed through the proxy. Comma separated list.|
|OPTIONS      |`-v`             |Optional variable to enable cntlm features.                                    |
|CUSTOM_CONFIG|                 |                                                                               |

> Find [technical details here](http://cntlm.sourceforge.net/cntlm_manual.pdf).

## Mount custom config

If you want to use an existing `cntlm.conf` you can mount it directly by settings the `CUSTOM_CONFIG` environment variable.

``` console
docker run --restart always --name cntlm \
  -e "CUSTOM_CONFIG=true" \
  -p 3128:3128 \
  -v /etc/cntlm.conf:/path/to/your/cntlm.conf \
  robertdebock/docker-cntlm
```

## Using in Docker Compose

You can use this container quite well in a docker-compose. Docker compose can simply be used to run as a stand-alone proxy. In that case the docker-compose.yml simply saves all variable, and can be started by running:

```console
docker-compose up
```

You can add the CNTLM service in a set of other containers, and let (outgoing) traffic from you application go through the cntlm proxy.
