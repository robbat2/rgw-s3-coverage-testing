#!/bin/bash
set -x

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
source /s3-tests/virtualenv/bin/activate 

# boto2 s3-tests 
# S3TEST_CONF=/s3-tests/s3tests.conf /s3-tests/virtualenv/bin/coverage run \
# --include=/s3-tests/virtualenv/lib/*/site-packages/boto/*,/s3-tests/s3tests/*,/s3-tests/s3tests_boto3/* \
# -m --branch -L nose --with-xunit --xunit-file=/s3-tests/nose-output.xml -v s3tests.functional.test_s3

# boto3 s3-tests 
# S3TEST_CONF=/s3-tests/s3tests.conf /s3-tests/virtualenv/bin/coverage run \
# --include=/s3-tests/virtualenv/lib/*/site-packages/boto/*,/s3-tests/s3tests/*,/s3-tests/s3tests_boto3/* \
# -m --branch -L nose --with-xunit --xunit-file=/s3-tests/nose-output.xml -v s3tests_boto3.functional.test_s3

S3TEST_CONF=/s3-tests/s3tests.conf /s3-tests/virtualenv/bin/coverage run \
--include=/s3-tests/virtualenv/lib/*/site-packages/boto/s3/*,/s3-tests/virtualenv/lib/*/site-packages/boto3/s3/*/s3-tests/s3tests/*,/s3-tests/s3tests_boto3/* \
-m --branch -L nose --with-xunit --xunit-file=/s3-tests/nose-output.xml -v "$@"

# Generates coverage.xml
/s3-tests/virtualenv/bin/coverage xml -o /s3-tests/coverage.xml

# Generates coverage.json
/s3-tests/virtualenv/bin/coverage json  --pretty-print -o /s3-tests/coverage.json

# Generates html coverage
/s3-tests/virtualenv/bin/coverage html -d /s3-tests/coverage_html

