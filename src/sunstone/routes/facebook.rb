require 'koala'

#use Rack::Session::Cookie, secret: 'xyz' #TODO

# override
post '/login' do
  halt 501
end

get '/login' do
  if (env['HTTP_REFERER'] == 'https://www.facebook.com/') then
    #hack the rack protection
    env.delete('HTTP_REFERER')
  end

  # Facebook auth. error
  if params[:error] then
    session['oauth'] = session['access_token'] = nil
    redirect '/'

  # got Facebook code
  elsif (session['oauth']) and (params[:code]) then
    # get the access token from facebook with your code
    session['access_token'] = session['oauth'].get_access_token(params[:code])
    build_session 
    redirect '/'

  else 
    # generate a new oauth object with your app data and your callback url
    logger.error(request.url)
    session['oauth'] = Koala::Facebook::OAuth.new(
      $conf[:facebook_app_id], 
      $conf[:facebook_app_secret],
      request.url
    )

    # redirect to facebook to get your code
    redirect session['oauth'].url_for_oauth_code({
      'scope' => ['public_profile', 'email']
    })
  end
end

post '/logout' do
  session['oauth'] = session['access_token'] = nil
  destroy_session
end
