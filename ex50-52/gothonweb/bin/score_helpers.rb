require './bin/class_variables.rb'

module ScoreHelpers
  include ClassVariables

  def show_score
    @@score
  end

  def reset_score
    @@score = 0
    reset_bonus_points
  end

  def reset_bonus_points
    @@time_bonus                    = 0
    @@total_time_bonus              = 0
    @@time_bonus_multiplier         = 0
    @@guesses_bonus                 = 0
    @@less_than_three_guesses_bonus = 0
    @@no_hints_used                 = true
    @@no_hints_bonus                = 0
    @@no_invalid_actions            = true
    @@no_invalid_actions_bonus      = 0
    @@bonus_added                   = false
  end

  def score_change
    @@score_change
  end

  def reset_score_change
    @@score_change = 0
  end

  def add_score_checking_guesses
    case @@guesses
    when 0 
      @@guesses_bonus = 50
    when 1
      @@guesses_bonus = 30
    else 
      @@guesses_bonus = 0
    end
    
    @@bonus_added = true if @@guesses_bonus != 0

    @@less_than_three_guesses_bonus += @@guesses_bonus

    @@score_change  = rand(18..20) + @@guesses_bonus
    @@score        += @@score_change
    @@score_change  = "+#{@@score_change}"
  end

  def no_hints_used_bonus?
    if @@no_hints_used
      @@no_hints_bonus += 100
      @@score          += @@no_hints_bonus
      @@bonus_added     = true
    end
  end

  # We only use this one in the winning room.
  def no_invalid_actions_bonus?
    if @@no_invalid_actions
      @@no_invalid_actions_bonus += 50
      @@score                    += @@no_invalid_actions_bonus
      @@bonus_added               = true
    end
  end

  def add_time_bonus_points
    # We create @@time_bonus, @@total_time_bonus and @@time_bonus_multiplier
    # to show them separately in the view and improve the experience.
    if @@total_time < 60

      @@time_bonus = 60 - @@total_time

      case @@total_time         
      when 40..49 then @@time_bonus_multiplier = 2
      when 30..39 then @@time_bonus_multiplier = 3
      when 20..29 then @@time_bonus_multiplier = 4
      when 10..19 then @@time_bonus_multiplier = 8
      when  0..9  then @@time_bonus_multiplier = 16
      end

      if @@time_bonus_multiplier == 0
        @@score += @@time_bonus
      else
        @@total_time_bonus = @@time_bonus * @@time_bonus_multiplier
        @@score           += @@total_time_bonus
        @@bonus_added      = true
      end
    end
  end

  def time_bonus?
    @@time_bonus != 0
  end

  def time_bonus
    @@time_bonus
  end

  def total_time_bonus
    @@total_time_bonus
  end

  def time_bonus_multiplier?
    @@time_bonus_multiplier != 0
  end

  def time_bonus_multiplier
    @@time_bonus_multiplier
  end

  def bonus_points
    @@bonus_points_hash
  end

  def total_bonus_points?
    total_bonus_points != 0
  end

  def total_bonus_points
    @@total_time_bonus              +
    @@no_hints_bonus                +
    @@less_than_three_guesses_bonus +
    @@no_invalid_actions_bonus
  end

  def create_bonus_points_hash
    @@bonus_points_hash = {
      "Less than one minute"    => @@total_time_bonus,
      "No hints used"           => @@no_hints_bonus,
      "Less than three guesses" => @@less_than_three_guesses_bonus,
      "No invalid actions"      => @@no_invalid_actions_bonus
    }
  end

  def bonus_added?
    @@bonus_added
  end
end
