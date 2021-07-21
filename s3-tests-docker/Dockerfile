FROM ubuntu:18.04
LABEL version="0.0.1"
LABEL authors="Saptarshi Majumder <saptarshimajumder19@gmail.com>, Robin H. Johnson <robbat2@orbis-terrarum.net>"

SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
apt-get install -y virtualenv git sudo gcc jq

# COPY s3tests.conf.SAMPLE ./s3tests.conf

RUN git clone https://github.com/ceph/s3-tests.git \
  && cd s3-tests \
  && echo coverage==5.5 >> requirements.txt \
  && echo intervaltree==3.1.0 >> requirements.txt \
  && ./bootstrap

ADD run-tests.sh s3tests.conf analyzer.py /
ADD s3tests.conf /s3-tests
ADD analyzer.py /s3-tests

RUN ["chmod","+x","/analyzer.py"]
RUN ["chmod","+x","/run-tests.sh"]
ENTRYPOINT ["/run-tests.sh"]