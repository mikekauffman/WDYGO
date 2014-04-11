require 'sinatra/base'
require 'json'
require 'net/https'

class Wdygo < Sinatra::Application

  CHECKINS = []
  CLIENT_ID = 'PZZRWLEPHKV1CK2DAYZXZC1QJOHVTAJSGJPUBWYRCFPD0C5A'
  CLIENT_SECRET = 'HIB3WWLEBLE2VATGRMZUVOCZZ4NLWEMDCP4VTGDY55YSMDKK'
  CALLBACK_PATH = 'http://wdygo.herokuapp.com/auth/foursquare/callback'

  get '/' do
    CHECKINS << params[:access_token]
    auth_link = "https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=token&redirect_uri=#{CALLBACK_PATH}"
    erb :index, locals: {checkins: CHECKINS, authorize: auth_link}
  end

  get '/privacy' do
    "You're data is never sold"
  end
  '/auth/foursquare/callback#access_token=AQ3DDXQTSF5L5Y0ZNQB03RC1L1DSHYLNI51YLO5E4Q3ISDEO'

  get '/auth/foursquare/callback#access_token=:access_token' do
    access_token = params[:access_token]
    CHECKINS << access_token
    redirect '/'
  end

  get '/checkins' do
    "Yep"
  end

  #def redirect_uri
  #  uri = URI.parse(request.url)
  #  uri.path = CALLBACK_PATH
  #  uri.query = nil
  #  uri.to_s
  #end
  #'https://foursquare.com/oauth2/access_token
  #?client_id=YOUR_CLIENT_ID
  #&client_secret=YOUR_CLIENT_SECRET
  #&grant_type=authorization_code
  #&redirect_uri=YOUR_REGISTERED_REDIRECT_URI
  #&code=CODE'
  #def client
  #  OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET,
  #                     :site => 'http://foursquare.com/v2/',
  #                     :request_token_path => "/oauth2/request_token",
  #                     :access_token_path  => "/oauth2/access_token",
  #                     :authorize_path     => "/oauth2/authenticate?response_type=code",
  #                     :parse_json => true
  #  )
  #end

end