FROM centos:7

RUN yum -y install http://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3-1.x86_64.rpm

ENV USERNAME   UNSET
ENV PASSWORD   UNSET
ENV DOMAIN     example.com
ENV PROXY      UNSET
ENV LISTEN     0.0.0.0:3128
ENV PASSLM     UNSET
ENV PASSNT     UNSET
ENV PASSNTLMV2 UNSET

ADD generatehash.sh /generatehash.sh

EXPOSE 3128

CMD echo "Username ${USERNAME}" > /etc/cntlm.conf && \
    if [ ${PASSWORD} != "UNSET" ] ; then echo "Password ${PASSWORD}" > /etc/cntlm.conf ; fi && \
    echo "Domain ${DOMAIN}" >> /etc/cntlm.conf && \
    echo "Proxy ${PROXY}" >> /etc/cntlm.conf && \
    echo "Listen ${LISTEN}" >> /etc/cntlm.conf && \
    if [ ${PASSLM} != "UNSET" ] ; then echo "PassLM ${PASSLM}" >> /etc/cntlm.conf ; fi && \
    if [ ${PASSNT} != "UNSET" ] ; then echo "PassNT ${PASSNT}" >> /etc/cntlm.conf ; fi && \
    if [ ${PASSNTLMV2} != "UNSET" ] ; then echo "PassNTLMv2 ${PASSNTLMV2}" >> /etc/cntlm.conf ; fi && \
    /usr/sbin/cntlm -c /etc/cntlm.conf -f
