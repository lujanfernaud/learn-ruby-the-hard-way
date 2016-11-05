require './bin/class_variables.rb'

module ApplicationHelpers
  include ClassVariables

  def name_error?
    @@activate_name_error || @@activate_name_length_error
  end

  def show_name_error
    return "Please write your name:" if @@activate_name_error
    return "The name is too long!"   if @@activate_name_length_error
  end

  def reset_name_errors
    @@activate_name_error        = false
    @@activate_name_length_error = false
  end

  def show_total_time
    @@total_time
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

    @@bzed
  end

  def door_did_not_open?
    @@door_locked
  end

  def guesses?
    @@guesses > 0
  end

  def check_guesses

    def find_error_message(first_messages = false, last_messages = false)
      @@error_messages_list = [
        "If you do what you always did, you will get what you always got.",       # [0]
        "That's not the code.",                                                   # [1]
        "Success is walking from failure to failure with no loss of enthusiasm.", # [2]
        "Wrong!",                                                                 # [3]
        # Last messages used when the last_message modifier is true :
        "Time is a drug. Too much of it kills you.",                              # [-4]
        "Million-to-one chances...crop up nine times out of ten.",                # [-3]
        "In the space between chaos and shape there was another chance.",         # [-2]
        "You're running out of opportunities."                                    # [-1]
      ]

      if first_messages
        @@error_messages_list = [@@error_messages_list[1], @@error_messages_list[3]]
      elsif last_messages
        @@error_messages_list = @@error_messages_list[-4..-1]
      else
        @@error_messages_list = @@error_messages_list[0..3]
      end

      @@error_message = @@error_messages_list.sample

      while @@error_message == @@previous_error_message
        @@error_message = @@error_messages_list.sample
      end

      @@previous_error_message = @@error_message

      @@error_message
    end

    if @@guesses == 1
      "<p>#{find_error_message(first_messages = true)}</p>
      <p>Tries left: #{6 - @@guesses}</p>"
    elsif @@guesses > 0 && @@guesses != 6
      "<p>#{find_error_message}</p>
      <p>Tries left: #{6 - @@guesses}</p>"
    elsif @@guesses == 6
      "<p>#{find_error_message(first_messages = false, last_messages = true)}</p>
      <p>Last try!</p>"
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
      elsif asterisk.zero? && round == 3
        n
      else
        asterisk = 1
        '*'
      end
    end
    hint.join.to_s
  end

  def show_door_hint(good_door, bad_door = nil, total_doors)
    good_door_number = [good_door.to_i]
    bad_door_number  = [bad_door.to_i] if bad_door
    doors_array      = [*1..total_doors]

    hint = if bad_door
             doors_array - good_door_number - bad_door_number
           else
             doors_array - good_door_number
           end

    switch = rand(0..1)

    if switch.zero?
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

  def show_winning_message(position)
    case position
    when 1
      "WOW! You achieved the maximum score!!"
    when 2..3
      "You are in the three best!!"
    when 4..10
      "You made it to the high scores!"
    else
      "Congratulations! You won!"
    end
  end

  def show_last_death_line
    death_lines = [
      "You died. You kinda suck at this.",
      "You died. Such a luser.",
      "I have a small puppy that's better at this."
    ]

    death_lines.sample
  end
end
