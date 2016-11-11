require './bin/class_variables.rb'

class Score < Sequel::Model
  include ClassVariables

  def self.save_user_data
    @@user_data = Score.new
    @@user_data[:user_name]  = @@user_name
    @@user_data[:total_time] = @@total_time
    @@user_data[:score]      = @@score
    @@user_data[:date]       = Time.now.strftime("%d %b %Y")
    @@user_data.save
  end

  def self.get_high_scores
    Score.reverse_order(:score).limit(10)
  end

  def self.get_user_position
    return unless @@user_data
    @all_scores_array      = Score.reverse_order(:score).to_a
    @current_user_in_array = @all_scores_array.detect { |user| user[:id] == @@user_data[:id] }

    @all_scores_array.index(@current_user_in_array)
  end
end
