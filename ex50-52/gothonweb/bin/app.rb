require 'sinatra/base'

require './lib/gothonweb/map.rb'
require './bin/class_variables.rb'
require './helpers/helpers.rb'

require 'pry-byebug'
require 'pry-inline'

class App < Sinatra::Base

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
    reset_progress
    reset_score
    reset_buzz_guesses_hint_and_door
    reset_actions
    @@activate_hint = false

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
    reset_actions
    @@activate_hint = false

    room   = Map::load_room(session)
    action = params[:action].downcase

    if room
      
      # If the room requires a code to continue.
      if room.code    

        if action == "hint!" && hint_not_used?
          @@activate_hint = true      
          @@hint_counter  = 1
          @@score        -= 3

        elsif action == room.code || action == "next!!"
          next_room = room.go(action)
          add_score_checking_guesses
          increase_progress
          reset_buzz_guesses_hint_and_door

        elsif action != room.code && @@guesses < 6
          @@activate_buzz = true
          @@guesses      += 1
          @@hint_counter  = 1
          @@score        -= 2

        else
          next_room = room.go('WRONG_CODE_DEATH')
          reset_buzz_guesses_hint_and_door
          reset_progress
        end

      # If the room requires us to choose a door.
      elsif room.doors

        if action == "hint!" && hint_not_used?
          @@activate_hint = true      
          @@hint_counter  = 1
          @@score        -= 3

        elsif action == room.good_door || action == "next!!"
          next_room = room.go(action)
          add_score_checking_guesses
          increase_progress
          reset_buzz_guesses_hint_and_door

        elsif action == room.bad_door
          next_room = room.go(action)
          reset_buzz_guesses_hint_and_door          

        elsif room.go(action) == "not compute" && @@guesses < 1
          @@door_locked = true
          @@guesses    += 1
          @@score      -= 2

        else
          next_room = room.go('THE_END_LOSER_2')
          reset_buzz_guesses_hint_and_door
          reset_progress
        end  

      # Else, the room is a normal room with actions.
      else

        if action == "actions"
          @@activate_actions = true

        # If the room we are going to is a death room.
        elsif Map::DEATH_ROOMS.include?(room.go(action))
          next_room = room.go(action)

        # If the room we are going to is the good one.
        elsif room.go(action) != "not compute"
          next_room = room.go(action)
          # We add score if the room we are in is not a death room or the winning room.
          # We do this to avoid increasing the score and progress when we want to play again.
          if !Map::DEATH_ROOMS.include?(room) && !room.player_won
            @@score += 20
            increase_progress
          else
            reset_progress
          end
        
        else
          @@action_does_not_exist = true
          @@score -= 1
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
end

App.run!