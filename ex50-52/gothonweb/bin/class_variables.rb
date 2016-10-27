module ClassVariables

  # User data:
  @@user_name                     = nil
  @@user_data                     = nil

  # Score:
  @@score                         = 0
  @@score_change                  = 0

  # Bonus points:
  @@time_bonus                    = 0
  @@time_bonus_multiplier         = 0
  @@total_time_bonus              = 0
  @@total_time_bonus_max          = 400 # add_time_bonus_points (50 seconds x8) (not including x16 because it's unlikely)
  @@guesses_bonus                 = 0
  @@less_than_three_guesses_bonus = 0
  @@guesses_bonus_max             = 100 # add_score_checking_guesses (50 x2)
  @@no_hints_used                 = true
  @@no_hints_bonus                = 0
  @@no_hints_bonus_max            = 200 # no_hints_used_bonus? (100 x2)
  @@no_invalid_actions            = true
  @@no_invalid_actions_bonus      = 0
  @@no_invalid_actions_bonus_max  = 50 # no_invalid_actions_bonus? (50 x1)
  @@bonus_added                   = false
  @@bonus_points_hash             = nil
  
  # Time:
  @@start_time                    = 0
  @@end_time                      = 0
  @@total_time                    = 0

  # Activators:
  @@activate_name_error           = false
  @@activate_name_length_error    = false
  @@action_does_not_exist         = false
  @@activate_actions              = false
  @@activate_actions_by_default   = true
  @@activate_hint                 = false
  @@activate_buzz                 = false
  
  # Messages:
  @@previous_bzed                 = nil
  @@bzed                          = nil
  @@error_message                 = nil
  @@previous_error_message        = nil
  @@door_locked                   = false  

  # Hints and guesses counters:
  @@hint_counter                  = 0
  @@guesses                       = 0
end
