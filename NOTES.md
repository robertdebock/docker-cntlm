

```
docker build . -t cntlm
docker login -u sergealexandre
docker tag cntlm ezcplugins/docker-cntlm:latest
docker push ezcplugins/docker-cntlm:latest
```
