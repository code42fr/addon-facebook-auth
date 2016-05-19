#!/bin/bash
SUNSTONE_CONF=${SUNSTONE_CONF:-/etc/one/sunstone-server.conf}
ONE_LIB=${ONE_LIB:-/usr/lib/one}

set -e
set -x

gem install koala
install -m 0644 src/sunstone/public/images/login-fb.png          ${ONE_LIB}/sunstone/public/images/
install -m 0644 src/sunstone/routes/facebook.rb                  ${ONE_LIB}/sunstone/routes/
install -m 0644 src/sunstone/views/_login_facebook.erb           ${ONE_LIB}/sunstone/views/
install -m 0644 src/cloud/common/CloudAuth/FacebookCloudAuth.rb  ${ONE_LIB}/ruby/cloud/CloudAuth/

grep -q facebook ${ONE_LIB}/ruby/cloud/CloudAuth.rb ||
  patch -N ${ONE_LIB}/ruby/cloud/CloudAuth.rb src/cloud/common/CloudAuth.rb.patch

grep -q facebook ${SUNSTONE_CONF} ||
  patch -N ${SUNSTONE_CONF} src/sunstone/etc/sunstone-server.conf.patch

echo 'Done'
