require 'sinatra/base'

class Wydgo < Sinatra::Application

  get '/' do
    erb :index
  end

end