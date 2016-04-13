FROM centos:7

RUN yum -y install http://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3-1.x86_64.rpm

ENV USERNAME     UNSET
ENV DOMAIN       example.com
ENV PROXY        UNSET
ENV LISTEN       127.0.0.1:3128
ENV PASSLMHASH   UNSET
ENV PASSNTHASH   UNSET
ENV PASSNTLMHASH UNSET

EXPOSE 3128

RUN sed -i "s/USERNAME/${USERNAME}/" /etc/cntlm.conf \
    sed -i "s/DOMAIN/${DOMAIN}/" /etc/cntlm.conf \
    sed -i "s/PROXY/${PROXY}/" /etc/cntlm.conf \
    sed -i "s/LISTEN/${LISTEN}/" /etc/cntlm.conf \
    sed -i "s/PASSLMHASH/${PASSLMHASH}/" /etc/cntlm.conf \
    sed -i "s/PASSNTHASH/${PASSNTHASH}/" /etc/cntlm.conf \
    sed -i "s/PASSNTLMHASH/${PASSNTLMHASH}/" /etc/cntlm.conf

CMD cntlm
