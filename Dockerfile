FROM alpine:latest
LABEL version="0.0.1"
LABEL authors="Saptarshi Majumder <saptarshimajumder19@gmail.com>, Robin H. Johnson <robbat2@orbis-terrarum.net>"

RUN apk add --no-cache py-virtualenv git sudo gcc python2-dev python2-dev \
       libc-dev libxml2-dev libxslt-dev libffi-dev

RUN git clone https://github.com/ceph/s3-tests.git

ADD run-tests.sh s3tests.conf /
ADD s3tests.conf /s3-tests

RUN  ["chmod","+x","/s3-tests/bootstrap.sh"]
CMD ["/s3-tests/bootstrap.sh"]

RUN ["chmod","+x","/run-tests.sh"]
ENTRYPOINT ["/run-tests.sh"]