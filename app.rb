require 'sinatra/base'
require 'oauth2'
require 'json'
require 'net/https'

class Wdygo < Sinatra::Application

  TOKENS = []
  CLIENT_ID = 'PZZRWLEPHKV1CK2DAYZXZC1QJOHVTAJSGJPUBWYRCFPD0C5A'
  CLIENT_SECRET = 'HIB3WWLEBLE2VATGRMZUVOCZZ4NLWEMDCP4VTGDY55YSMDKK'
  CALLBACK_PATH = '/auth/foursquare/callback'

  def client
    OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET,
                       {
                         :site => 'http://foursquare.com/',
                         :request_token_path => "/oauth2/request_token",
                         :access_token_path => "/oauth2/access_token",
                         :authorize_path => "/oauth2/authenticate?response_type=code",
                         :parse_json => true,
                         #:ssl => {:ca_path => '/etc/ssl/certs'}
                       }
    )
  end

  get '/' do
    auth_link = "https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{redirect_uri}"
    erb :index, locals: {tokens: TOKENS, authorize: auth_link}
  end

  get '/privacy' do
    "You're data is never sold"
  end

  get '/auth/foursquare/callback' do
    p "BROKE BEFORE IF BLOCK"
    if params[:code] != nil
      p "GOT INSIDE IF BLOCK HERE: #{params[:code]}"
      access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
    else
      p "NO PARAMS CODE HERE:"
      'Missing response from foursquare'
    end
      p "GOT THROUGH THE IF BLOCK HERE: #{params[:code]}"

    #user = access_token.get('https://api.foursquare.com/v2/users/self')
    #user.inspect

    TOKENS << access_token
    redirect '/'
  end

  get '/checkins' do
    "Yep"
  end

  def redirect_uri()
    uri = URI.parse(request.url)
    uri.path = CALLBACK_PATH
    uri.query = nil
    uri.to_s
  end

end