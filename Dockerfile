FROM centos:7

RUN yum -y install http://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3-1.x86_64.rpm

ENV USERNAME   UNSET
ENV PASSWORD   UNSET
ENV DOMAIN     example.com
ENV PROXY      UNSET
ENV LISTEN     127.0.0.1:3128
ENV PASSLM     UNSET
ENV PASSNT     UNSET
ENV PASSNTLMV2 UNSET


EXPOSE 3128

CMD echo "Username ${USERNAME}" > /etc/cntlm.conf && \
    if [ ${PASSWORD} != "UNSET" ] ; then echo "Password ${PASSWORD}" > /etc/cntlm.conf ; fi && \
    echo "Domain ${DOMAIN}" >> /etc/cntlm.conf && \
    echo "Proxy ${PROXY}" >> /etc/cntlm.conf && \
    echo "Listen ${LISTEN}" >> /etc/cntlm.conf && \
    echo "PassLM ${PASSLM}" >> /etc/cntlm.conf && \
    echo "PassNT ${PASSNT}" >> /etc/cntlm.conf && \
    echo "PassNTLMv2 ${PASSNTLMV2}" >> /etc/cntlm.conf && \
    /usr/sbin/cntlm -c /etc/cntlm.conf -f
