#!/bin/sh
set -e

# TODO: Configs for test coverage

# TODO: coverage.py run for botov3 and botov2

# Configuration (More configs needs to be set)
if [ ! -z "$S3_HOST" ]; then
  echo "Setting S3 host to $S3_HOST"
  sed -i -e "s@^host =.*@host = $S3_HOST@g" \
    /s3tests.conf
fi
if [ ! -z "$S3_PORT" ]; then
  echo "Setting S3 port to $S3_PORT"
  sed -i -e "s@^port =.*@port = $S3_PORT@g" \
    /s3tests.conf
fi
if [ ! -z "$S3_IS_SECURE" ]; then
  echo "Setting S3 port to $S3_IS_SECURE"
  sed -i -e "s@^is_secure =.*@is_secure = $S3_IS_SECURE@g" \
    /s3tests.conf
fi
if [ ! -z "$S3_BUCKET_PREFIX" ]; then
  echo "Setting bucket prefix to $S3_BUCKET_PREFIX"
  sed -i -e "s@^bucket prefix =.*@bucket prefix = $S3_BUCKET_PREFIX@g" \
    /s3tests.conf
fi
if [ ! -z "$S3_MAIN_DISPLAY_NAME" ]; then
  echo "Setting main display name to $S3_MAIN_DISPLAY_NAME"
  sed -i -e "s@^display_name = admin@display_name = $S3_MAIN_DISPLAY_NAME@g" \
    /s3tests.conf
fi
if [ ! -z "$S3_MAIN_ACCESS_KEY" ]; then
  echo "Setting main access key to $S3_MAIN_ACCESS_KEY"
  sed -i -e "s@^access_key = admin:admin@access_key = $S3_MAIN_ACCESS_KEY@g" \
    /s3tests.conf
fi
if [ ! -z "$S3_MAIN_SECRET_KEY" ]; then
  echo "Setting main secret key to $S3_MAIN_SECRET_KEY"
  sed -i -e "s@^secret_key = admin@secret_key = $S3_MAIN_SECRET_KEY@g" \
    /s3tests.conf
fi
if [ ! -z "$S3_ALT_DISPLAY_NAME" ]; then
  echo "Setting alt display name to $S3_ALT_DISPLAY_NAME"
  sed -i -e "s@^display_name = test2@display_name = $S3_ALT_DISPLAY_NAME@g" \
    /s3tests.conf
fi
if [ ! -z "$S3_ALT_ACCESS_KEY" ]; then
  echo "Setting alt access key to $S3_ALT_ACCESS_KEY"
  sed -i -e "s@^access_key = test:tester@access_key = $S3_ALT_ACCESS_KEY@g" \
    /s3tests.conf
fi
if [ ! -z "$S3_ALT_SECRET_KEY" ]; then
  echo "Setting alt secret key to $S3_ALT_SECRET_KEY"
  sed -i -e "s@^secret_key = testing@secret_key = $S3_ALT_SECRET_KEY@g" \
    /s3tests.conf
fi

# Start tests
echo 'Starting s3-tests ...'
#Checking whether virtualenv exists or not (i.e bootstrap ran or not)
for entry in "/s3-tests"/*
do
  echo "$entry"
done
source /s3-tests/virtualenv/bin/activate \
  && S3TEST_CONF=/s3tests.conf /s3-tests/virtualenv/bin/nosetests "$@"