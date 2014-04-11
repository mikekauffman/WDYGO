require 'sinatra/base'
require 'oauth2'
require 'json'
require 'net/https'

class Wdygo < Sinatra::Application

  CHECKINS = []
  CLIENT_ID = 'PZZRWLEPHKV1CK2DAYZXZC1QJOHVTAJSGJPUBWYRCFPD0C5A'
  CLIENT_SECRET = 'HIB3WWLEBLE2VATGRMZUVOCZZ4NLWEMDCP4VTGDY55YSMDKK'
  CALLBACK_PATH = 'http://wdygo.herokuapp.com/auth/foursquare/callback'

  get '/' do
    auth_link = "https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{CALLBACK_PATH}"
    erb :index, locals: {checkins: CHECKINS, authorize: auth_link}
  end

  get '/privacy' do
    "You're data is never sold"
  end

  get '/auth/foursquare/callback' do
    uri = URI.parse("https://foursquare.com/oauth2/access_token?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&grant_type=authorization_code&redirect_uri=#{redirect_uri}&code=" + params[:code])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = JSON.parse(http.request(request).body)
    access_token = OAuth2::AccessToken.new(client, response["access_token"])
    user = access_token.get('https://api.foursquare.com/v2/users/self/checkins')
    CHECKINS << user.inspect

    redirect '/'
  end

  get '/checkins' do
    "Yep"
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = CALLBACK_PATH
    uri.query = nil
    uri.to_s
  end

  def client
    OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET,
                       :site => 'http://foursquare.com/v2/',
                       :request_token_path => "/oauth2/request_token",
                       :access_token_path  => "/oauth2/access_token",
                       :authorize_path     => "/oauth2/authenticate?response_type=code",
                       :parse_json => true
    )
  end

end