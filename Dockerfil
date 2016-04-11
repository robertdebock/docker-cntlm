FROM centos:7

COPY cntlm-0.92.3-1.x86_64.rpm /root/cntlm-0.92.3-1.x86_64.rpm
#COPY cntlm.conf /etc/cntlm.conf

RUN yum -y localinstall /root/cntlm-0.92.3-1.x86_64.rpm && \
    yum clean all

EXPOSE 3128
#CMD cntlm -c /etc/cntlm.conf
CMD cntlm
