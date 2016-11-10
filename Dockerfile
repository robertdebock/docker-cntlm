FROM alpine

RUN apk add --no-cache curl gcc make musl-dev
RUN curl -o /cntlm-0.92.3.tar.gz \
    http://kent.dl.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.gz && \
    tar -xvzf /cntlm-0.92.3.tar.gz && \
    cd /cntlm-0.92.3 && \
    ./configure && \
    make && \
    make install && \
    rm /cntlm-0.92.3.tar.gz && \
    rm -Rf /cntlm-0.92.3

ENV USERNAME   example
ENV PASSWORD   UNSET
ENV DOMAIN     example.com
ENV PROXY      example.com:3128
ENV LISTEN     0.0.0.0:3128
ENV PASSLM     UNSET
ENV PASSNT     UNSET
ENV PASSNTLMV2 UNSET

ADD start.sh start.sh

EXPOSE 3128

CMD chmod +x /start.sh && \
    /start.sh
