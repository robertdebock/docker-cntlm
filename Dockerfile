FROM alpine

RUN apk add --no-cache curl gcc make musl-dev && \
    curl -o /cntlm-0.92.3.tar.gz http://kent.dl.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.gz && \
    tar -xvzf /cntlm-0.92.3.tar.gz && \
    cd /cntlm-0.92.3 && ./configure && make && make install && cd ../ && \
    rm -Rf cntlm-0.92.3.tar.gz cntlm-0.92.3 && \
    apk del --no-cache curl gcc make musl-dev

ENV USERNAME   example
ENV PASSWORD   UNSET
ENV DOMAIN     example.com
ENV PROXY      example.com:3128
ENV LISTEN     0.0.0.0:3128
ENV PASSLM     UNSET
ENV PASSNT     UNSET
ENV PASSNTLMV2 UNSET

EXPOSE 3128

CMD echo "Preparing a proxy on ${LISTEN}, connecting to ${PROXY}. (Username: ${USERNAME}, domain: ${DOMAIN})" && \
    echo "Username ${USERNAME}" > /etc/cntlm.conf && \
    if [ ${PASSWORD} != "UNSET" ] ; then echo "Password ${PASSWORD}" >> /etc/cntlm.conf ; fi && \
    echo "Domain ${DOMAIN}" >> /etc/cntlm.conf && \
    echo "Proxy ${PROXY}" >> /etc/cntlm.conf && \
    echo "Listen ${LISTEN}" >> /etc/cntlm.conf && \
    if [ ${PASSLM} != "UNSET" ] ; then echo "PassLM ${PASSLM}" >> /etc/cntlm.conf ; fi && \
    if [ ${PASSNT} != "UNSET" ] ; then echo "PassNT ${PASSNT}" >> /etc/cntlm.conf ; fi && \
    if [ ${PASSNTLMV2} != "UNSET" ] ; then echo "PassNTLMv2 ${PASSNTLMV2}" >> /etc/cntlm.conf ; fi && \
    /usr/sbin/cntlm -c /etc/cntlm.conf -f -v
    
HEALTHCHECK --interval=5s --timeout=3s CMD http_proxy=http://localhost:3128 curl --fail http://google.com/ || exit 1
