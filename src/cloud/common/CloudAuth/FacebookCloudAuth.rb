require 'koala'

module FacebookCloudAuth
    # build ON user XML 
    def user_update_profile(user, key, value)
      if value 
        user.update(<<XML, true)
<USER>
  <#{key}><![CDATA[#{value}]]></#{key}>
</USER>
XML
      end
    end

    def do_auth(env, params={})
      access_token = env['rack.session']['access_token']
      graph = Koala::Facebook::API.new(access_token)
      me = graph.get_object('me', {'fields'=>'id,name,email,locale,link'})

      if me['id']
        # check if user exists
        user_id = 'fb_' + me['id']
        user = OpenNebula::User.new_with_id(user_id, client)
        rc = user.info

        if OpenNebula.is_error?(rc) or rc.nil?
          # create new one
          user = OpenNebula::User.new(User.build_xml(), client)
          user.allocate(user_id, 'kokotina') 

          { 'name'   => 'NAME',
            'email'  => 'EMAIL',
            'id'     => 'FB_ID',
            'link'   => 'FB_LINK',
            'locale' => 'FB_LOCALE',
          }.each { |fb_key, key|
            self.user_update_profile(user, key, me[fb_key])
          }

          # locales mapping
          fb_locale = me['locale']
          if $conf[:facebook_locales].has_key?(fb_locale.to_sym)
            locale = $conf[:facebook_locales][fb_locale.to_sym]
            if locale.nil? then locale = fb_locale end
            self.user_update_profile(user, 'LANG', locale)
          end
        end

        return user_id
      end

      return nil
    end

end
