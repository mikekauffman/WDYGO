require 'sinatra/base'
require 'faraday'
require 'json'
require 'net/https'
require 'open-uri'

class Wdygo < Sinatra::Application

  TOKENS = []
  CLIENT_ID = 'PZZRWLEPHKV1CK2DAYZXZC1QJOHVTAJSGJPUBWYRCFPD0C5A'
  CLIENT_SECRET = 'HIB3WWLEBLE2VATGRMZUVOCZZ4NLWEMDCP4VTGDY55YSMDKK'
  CALLBACK_PATH = '/auth/foursquare/callback'

  get '/' do
    auth_link = "https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{redirect_uri}"
    checkins = []
    if TOKENS[0]
      data_parse.each do |data|
        checkins << data[:response][:checkins][:items]
      end
    end
    erb :index, locals: {authorize: auth_link, checkins: checkins}
  end

  get '/auth/foursquare/callback' do
    string = Faraday.get("https://foursquare.com/oauth2/access_token?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&grant_type=authorization_code&redirect_uri=#{redirect_uri}&code=#{params[:code]}").body
    hash = JSON.parse(string)
    access_token = hash['access_token']
    TOKENS[0] = access_token
    redirect '/'
  end

  get '/checkins' do
    "Yep"
  end

  get '/privacy' do
    "You're data is never sold"
  end

  get '/map' do
    checkins = []
    if TOKENS[0]
      data_parse.each do |data|
        checkins << data[:response][:checkins][:items]
      end
    end
    p checkins
      erb :map, locals: {checkins: checkins}
    end

    private

    def redirect_uri()
      uri = URI.parse(request.url)
      uri.path = CALLBACK_PATH
      uri.query = nil
      uri.to_s
    end

    def data_parse
      first_string = Faraday.get("https://api.foursquare.com/v2/users/self/checkins?offset=0&limit=250&oauth_token=#{TOKENS[0]}&v=20140418").body
      second_string = Faraday.get("https://api.foursquare.com/v2/users/self/checkins?offset=250&limit=500&oauth_token=#{TOKENS[0]}&v=20140418").body
      third_string = Faraday.get("https://api.foursquare.com/v2/users/self/checkins?offset=500&limit=750&oauth_token=#{TOKENS[0]}&v=20140418").body
      fourth_string = Faraday.get("https://api.foursquare.com/v2/users/self/checkins?offset=750&limit=1000&oauth_token=#{TOKENS[0]}&v=20140418").body
      fifth_string = Faraday.get("https://api.foursquare.com/v2/users/self/checkins?offset=1000&limit=1250&oauth_token=#{TOKENS[0]}&v=20140418").body
      data_array = []
      d_one = JSON.parse(first_string, symbolize_names: true)
      d_two = JSON.parse(second_string, symbolize_names: true)
      d_three = JSON.parse(third_string, symbolize_names: true)
      d_four = JSON.parse(fourth_string, symbolize_names: true)
      d_five = JSON.parse(fifth_string, symbolize_names: true)
      data_array << d_one
      data_array << d_two
      data_array << d_three
      data_array << d_four
      data_array << d_five
      data_array
    end

  end
