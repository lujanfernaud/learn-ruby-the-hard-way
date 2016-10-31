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

  def self.high_scores
    Score.reverse_order(:score).limit(10)
  end
end