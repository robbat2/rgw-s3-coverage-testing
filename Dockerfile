FROM ubuntu:18.04
LABEL version="0.0.1"
LABEL authors="Saptarshi Majumder <saptarshimajumder19@gmail.com>, Robin H. Johnson <robbat2@orbis-terrarum.net>"

SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
apt-get install -y virtualenv git sudo gcc 

RUN git clone https://github.com/ceph/s3-tests.git \
  && cd s3-tests \
  && ./bootstrap

ADD run-tests.sh s3tests.conf /
ADD s3tests.conf /s3-tests

# RUN /run-tests.sh
RUN ["chmod","+x","/run-tests.sh"]
ENTRYPOINT ["/run-tests.sh"]