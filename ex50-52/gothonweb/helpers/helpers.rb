require './bin/class_variables.rb'

module Helpers
  include ClassVariables

  def show_score
    @@score
  end

  def reset_score
    @@score = 0
  end

  def add_score_checking_guesses
    case @@guesses
      when 0 then @@score += 50
      when 1 then @@score += 30
      else @@score += 20
    end
  end

  def does_not_compute?
    @@action_does_not_exist
  end

  def show_actions?
    @@activate_actions
  end

  def show_actions_by_default?
    @@activate_actions_by_default
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

  def buzz
    while @@bzed == @@previous_bzed
      z = "Z" * rand(4..6)

      @@bzed = "B" + z + "ED"
    end

    @@previous_bzed = @@bzed

    "<p>#{@@bzed}</p>"
  end

  def door_did_not_open?
    @@door_locked
  end

  def guesses?
    @@guesses > 0
  end

  def check_guesses
    if @@guesses > 0 && @@guesses != 6
      "<p>Tries left: #{6 - @@guesses}</p>"
    elsif @@guesses == 6
      "<p>Last try!</p>"
    end
  end

  def show_code_hint(code)
    asterisk = rand(0..1)
    round    = 0

    hint = code.split("").collect do |n|
      round += 1
      # If there's an asterisk (asterisk == 1), it puts a number and sets asterisks to 0,
      # else it puts an asterisk and sets asterisk to 1. This way we alternate them.
      if asterisk == 1
        asterisk = 0
        n
      # If we are in round 3 and we have asterisk == 0 (the previous character is a number),
      # then we put another number. Otherwise we would have two asterisks and it would be
      # too difficult to guess the number.  
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
    
    if bad_door
      hint = doors_array - good_door_number - bad_door_number
    else
      hint = doors_array - good_door_number
    end
    
    switch = rand(0..1)

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

  def reset_actions
    @@action_does_not_exist = false
    @@activate_actions      = false
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