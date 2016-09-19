require 'sinatra'
require './lib/gothonweb/map.rb'

require 'pry'

configure do
  set :port, 8080
  set :static, true
  set :public_folder, "static"
  set :views, "views"

  enable :sessions
  set    :session_secret, 'BADSECRET'
end

get '/' do
  session[:room] = 'START'
  redirect '/game'
end

get '/game' do
  room = Map::load_room(session)
  Map::save_room(session, room)

  if room
    erb :show_room, :locals => {:room => room}
  else
    erb :you_died
  end
end

post '/game' do
  room   = Map::load_room(session)
  action = params[:action].downcase

  if room
    next_room = room.go(action) || room.go('*')

    if next_room
      Map::save_room(session, next_room)
    end

    redirect '/game'
  else
    erb :you_died
  end
end