FROM centos:7

RUN yum -y install http://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3-1.x86_64.rpm

ENV USERNAME
ENV DOMAIN example.com
ENV PROXY
ENV LISTEN 127.0.0.1:3128

EXPOSE 3128

CMD cntlm
