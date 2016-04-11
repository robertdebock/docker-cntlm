FROM centos:7

RUN yum -y install http://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3-1.x86_64.rpm

EXPOSE 3128
CMD cntlm
