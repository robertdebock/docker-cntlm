[![](https://images.microbadger.com/badges/image/robertdebock/docker-cntlm.svg)](http://microbadger.com/images/robertdebock/docker-cntlm "Get your own image badge on microbadger.com") [![Build Status](https://travis-ci.org/robertdebock/docker-cntlm.svg?branch=master)](https://travis-ci.org/robertdebock/docker-cntlm)

# docker-cntlm

A container to function as a proxy, based on [Cntlm](http://cntlm.sourceforge.net). Other containers can link to this one for their web access. This container authenticates to an external proxy and can be used by other containers without authentication details.

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
  -e "USERNAME=username" \
  -e "DOMAIN=mydomain" \
  -e "PROXY=anything:1234" \
  --rm -it robertdebock/docker-cntlm -H
```

Now you have to enter your password (which will not be displayed) and press enter.

Replace:
- `username` for your own username.
- `mydomain` for you own domain.

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
  -e "USERNAME=username" \
  -e "DOMAIN=mydomain" \
  -e "PASSNTLMV2=640937B847F8C6439D87155508FA8479" \
  -e "PROXY=123.123.123.123:8080" \
  -p 3128:3128 \
  robertdebock/docker-cntlm
```

Other settings you might want to use are:

| Variable      | Description                                                                                                                                | Example                         |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------- |
| USERNAME      | Your username for the proxy.                                                                                                               |                                 |
| PASSWORD      | The password of the user. Should be avoided to use. Go with NTLM tokens.                                                                   |                                 |
| DOMAIN        | Your domain for the proxy.                                                                                                                 |                                 |
| LISTEN        | The IP/hostname and port (separated by a colon) to listen to.                                                                              | `127.0.0.1:8080`                |
| PASSNTLMV2    | Required for auth method Auth NTLMv2.                                                                                                      |                                 |
| AUTH          | Auth parameter.                                                                                                                            |                                 |
| PASSNT        | Required for auth method Auth NTLM2SR, Auth NT and Auth NTLM.                                                                              |                                 |
| PASSLM        | Required for auth method Auth LM and Auth NTLM.                                                                                            |                                 |
| PROXY         | A proxy list the traffic is send to. Can be a list separated by `;`. Will be splitted into multiple `Proxy ...` lines in the `cntlm.conf`. | `localhost:3128;localhost:3129` |
| NOPROXY       | For address which should not be routed through the proxy. Comma separated list.                                                            | `127.0.0.1, 10.*`               |
| OPTIONS       | Optional variable to enable cntlm features.                                                                                                | `-v` for debugging              |
| CUSTOM_CONFIG | If you want to manually mount a config you can set this variable to skip all settings. Should be mounted into `etc/cntlm.conf`.            |                                 |

Find [technical details here](http://cntlm.sourceforge.net/cntlm_manual.pdf).

## Mount custom config

If you want to use an existing `cntlm.conf` you can mount it directly by settings the `CUSTOM_CONFIG` environment variable.

``` console
docker run --restart always --name cntlm \
  -e "CUSTOM_CONFIG=true" \
  -p 3128:3128 \
  -v /path/to/cntlm.conf:/etc/cntlm.conf \
  robertdebock/docker-cntlm
```

## Using in Docker Compose

You can use this container quite well in a docker-compose. Docker compose can simply be used to run as a stand-alone proxy. In that case the docker-compose.yml simply saves all variable, and can be started by running:

```console
docker-compose up
```

You can also add the cntlm service in a set of other containers, and let (outgoing) traffic from you application go through the cntlm proxy.
