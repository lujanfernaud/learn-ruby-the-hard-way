module ClassVariables

  @@user_name                   = nil
  @@user_data                   = nil

  @@score                       = 0
  @@score_change                = 0

  @@time_bonus                    = 0
  @@total_time_bonus              = 0
  @@bonus_multiplier              = 0
  @@less_than_three_guesses_bonus = 0
  @@no_hints_bonus                = 0
  @@no_invalid_actions_bonus      = 0
  
  @@bonus_points_hash = {
    "Less than one minute"    => @@time_bonus,
    "Less than three guesses" => @@less_than_three_guesses_bonus,
    "No hints used"           => @@no_hints_bonus,
    "No invalid actions"      => @@no_invalid_actions_bonus
  }
  
  @@start_time                  = 0
  @@end_time                    = 0
  @@total_time                  = 0

  @@activate_name_error         = false
  @@activate_name_length_error  = false
  @@action_does_not_exist       = false
  @@activate_actions            = false
  @@activate_actions_by_default = true
  @@activate_hint               = false
  @@activate_buzz               = false
  @@previous_bzed               = nil
  @@bzed                        = nil
  @@error_message               = nil
  @@previous_error_message      = nil
  @@door_locked                 = false
  
  @@hint_counter                = 0
  @@guesses                     = 0
end