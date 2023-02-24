FROM alpine:3

LABEL maintainer="Robert de Bock <robert@meinit.nl>"
LABEL version="1.4"
LABEL build_date="2023-02-24"

RUN apk add curl && \
    apk add --no-cache --virtual .build-deps gcc make musl-dev && \
    curl -o /cntlm-0.92.3.tar.gz 'https://deac-ams.dl.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.gz' && \
    tar -xvzf /cntlm-0.92.3.tar.gz && \
    cd /cntlm-0.92.3 && ./configure && make && make install && \
    rm -Rf cntlm-0.92.3.tar.gz cntlm-0.92.3 && \
    apk del --no-cache .build-deps

EXPOSE 3128

ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
