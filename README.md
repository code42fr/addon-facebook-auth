# OpenNebula Sunstone Facebook authentication

This code adds public Facebook authentication into OpenNebula Sunstone.
It's provided as is without any warranty as part of
[TryOpenNebula.org](http://www.tryopennebula.org) community demo site.

## Install

Run provided `install.sh` to patch installed OpenNebula. E.g.:

```bash
./install.sh
+ gem install koala
Successfully installed koala-2.3.0
Parsing documentation for koala-2.3.0
1 gem installed
+ install -m 0644 src/sunstone/public/images/login-fb.png /usr/lib/one/sunstone/public/images/
+ install -m 0644 src/sunstone/routes/facebook.rb /usr/lib/one/sunstone/routes/
+ install -m 0644 src/sunstone/views/_login_facebook.erb /usr/lib/one/sunstone/views/
+ install -m 0644 src/cloud/common/CloudAuth/FacebookCloudAuth.rb /usr/lib/one/ruby/cloud/CloudAuth/
+ grep -q facebook /usr/lib/one/ruby/cloud/CloudAuth.rb
+ patch -N /usr/lib/one/ruby/cloud/CloudAuth.rb src/cloud/common/CloudAuth.rb.patch
patching file /usr/lib/one/ruby/cloud/CloudAuth.rb
+ grep -q facebook /etc/one/sunstone-server.conf
+ patch -N /etc/one/sunstone-server.conf src/sunstone/etc/sunstone-server.conf.patch
patching file /etc/one/sunstone-server.conf
Hunk #1 succeeded at 73 (offset 1 line).
Hunk #2 succeeded at 87 (offset 1 line).
Hunk #3 succeeded at 233 (offset 40 lines).
+ echo Done
Done
```

## Configuration

You have to generate you own Facebook Application ID and secret on
[Facebook for Developers](https://developers.facebook.com/docs/apps/register)
and set in `/etc/one/sunstone-server.conf`:

```
:facebook_app_id: XXXXXXXXXXXXXXXX
:facebook_app_secret: YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
```

***

Vlastimil Holer, <vlastimil.holer@gmail.com>
