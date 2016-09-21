require 'sinatra'
require './lib/gothonweb/map.rb'

require 'pry-byebug'
require 'pry-inline'

configure do
  set :port, 8080
  set :static, true
  set :public_folder, "static"
  set :views, "views"

  enable :sessions
  set    :session_secret, 'BADSECRET'

  @@action_does_not_exist = false
  @@activate_actions      = false
  @@activate_hint         = false
end

helpers do
  def does_not_compute?
    @@action_does_not_exist
  end

  def show_actions?
    @@activate_actions
  end

  def show_hint?
    @@activate_hint
  end

  def show_last_death_line
    quips = [
      "You died. You kinda suck at this.",
      "You died. Such a luser.",
      "I have a small puppy that's better at this."
    ]

    quips[rand(0..(quips.length-1))]
  end
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
  @@action_does_not_exist = false
  @@activate_actions      = false
  @@activate_hint         = false

  room   = Map::load_room(session)
  action = params[:action].downcase

  if room
    if action == "actions"
      @@activate_actions = true
    elsif action == "hint!"  
      @@activate_hint = true
    elsif room.go(action) != "not compute"
      next_room = room.go(action) || room.go('*')
    else
      @@action_does_not_exist = true
    end

    if next_room
      Map::save_room(session, next_room)
    end

    redirect '/game'
  else
    erb :you_died
  end
end
