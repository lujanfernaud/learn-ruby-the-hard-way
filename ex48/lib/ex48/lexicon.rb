class Lexicon

  # We are going to use this hash to create the pairs.
  # If a user writes 'go to the south', we would split the string, 
  # scan this hash with each item of the string-array, and every time
  # we find the item, we save the key ('verb') with the item ('go')
  # to an array. Then we save all those arrays into the @result array.

  @lexicon_hash = { "direction" => ["north",
                                    "south",
                                    "east",
                                    "west",
                                    "down",
                                    "up",
                                    "left",
                                    "right",
                                    "back"],
                    "verb"      => ["go",
                                    "stop",
                                    "kill",
                                    "eat"],
                    "stop"      => ["to",
                                    "the",
                                    "in",
                                    "of",
                                    "from",
                                    "at",
                                    "it"],
                    "noun"      => ["door",
                                    "bear",
                                    "princess",
                                    "cabinet"] }

  def self.scan(string)
    array = string.split
    @pair = []
    @result = []
    array.each do |item|

      # We check if item is a number.
      # If it's not, we iterate over @lexicon_hash.
      # If we find the item, we push the item and the key it's into,
      # into the @pair array.
      # We push this pair into the @result array, we clean the @pair
      # array, and we start again.
      # If item is a number, we simply push 'number' and the 
      # converted number. 

      if self.convert_to_number(item) == nil
        @lexicon_hash.each_key do |key| 
          @pair << key << item if @lexicon_hash[key].include?(item) 
        end
      else
        number = self.convert_to_number(item)
        @pair << "number" << number
      end     
      @result << @pair
      @pair = []
    end
    @result
  end

  def self.convert_to_number(object)
    begin
      Integer(object)
    rescue
      nil
    end
  end

end
