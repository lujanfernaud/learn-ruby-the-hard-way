require 'sinatra'

require './lib/gothonweb/map.rb'
require './bin/class_variables.rb'
require './helpers/helpers.rb'

require 'pry-byebug'
require 'pry-inline'

configure do
  set    :port,           8080
  set    :static,         true
  set    :public_folder,  "static"
  set    :views,          "views"

  enable :sessions
  set    :session_secret, "BADSECRET"
end

include ClassVariables

helpers Helpers

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

  room    = Map::load_room(session)
  action  = params[:action].downcase

  if room
    if room.code    
      if action == "hint!" && hint_not_used?
        @@activate_hint = true      
        @@hint_counter = 1
      elsif room.go(action) != "not compute"
        next_room = room.go(action)
        reset_buzz_guesses_hint_and_door
      elsif action != room.code && @@guesses < 6
        @@activate_buzz = true
        @@guesses += 1
      else
        next_room = room.go('WRONG_CODE_DEATH')
        reset_buzz_guesses_hint_and_door
      end
    elsif room.doors
      if action == "hint!" && hint_not_used?
        @@activate_hint = true      
        @@hint_counter = 1
      elsif room.go(action) != "not compute"
        next_room = room.go(action)
        reset_buzz_guesses_hint_and_door
      elsif room.go(action) == "not compute" && @@guesses < 1
        @@door_locked = true
        @@guesses += 1
      else
        next_room = room.go('THE_END_LOSER_2')
        reset_buzz_guesses_hint_and_door
      end  
    else
      if action == "actions"
        @@activate_actions = true
      elsif room.go(action) != "not compute"
        next_room = room.go(action) || room.go('*')
      else
        @@action_does_not_exist = true
      end
    end

    if next_room
      Map::save_room(session, next_room)
    end

    redirect '/game'
  else
    erb :you_died
  end
end