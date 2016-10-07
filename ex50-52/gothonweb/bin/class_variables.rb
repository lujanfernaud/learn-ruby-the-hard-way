module ClassVariables

  @@user_name                   = nil
  @@score                       = 0
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
  @@door_locked                 = false
  
  @@hint_counter                = 0
  @@guesses                     = 0
end