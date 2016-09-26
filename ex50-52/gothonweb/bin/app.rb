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
  @@activate_buzz         = false
  @@door_locked           = false
  @@hint_counter          = 0
  @@guesses               = 0
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

  def hint_not_used?
    @@hint_counter == 0
  end

  def buzzed?
    @@activate_buzz
  end

  def door_did_not_open?
    @@door_locked
  end

  def show_code_hint(code)
    asterisk = rand(0..1)
    # We want to know which round we are in in the loop.
    # If we are in round 3 and we have asterisk = 0 (the previous character is a number),
    # then we put another number. Otherwise we would have two asterisks and it would be
    # too difficult to guess the number.
    round = 0

    hint = code.split("").collect do |n|
      round += 1
      # If there's an asterisk (asterisk = 1), it puts a number and sets asterisks to 0,
      # else it puts an asterisk and sets asterisk to 1. This way we alternate them.
      if asterisk == 1
        asterisk = 0
        n
      elsif asterisk == 0 && round == 3
        n
      else
        asterisk = 1
        '*'
      end
    end
    hint.join.to_s
  end

  def show_door_hint(good_door, bad_door=nil, total_doors)
    good_door_number = [good_door.to_i]
    bad_door_number  = [bad_door.to_i] if bad_door
    doors_array      = [*1..total_doors]
    hint             = doors_array - good_door_number - bad_door_number
    switch           = rand(0..1)

    if switch == 0
      hint.shift
    else
      hint.pop
    end

    hint.join(", ")
  end

  def reset_buzz_guesses_hint_and_door
    @@activate_buzz = false      
    @@guesses       = 0
    @@hint_counter  = 0
    @@door_locked   = false
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
