class ParserError < Exception; end

class Sentence

  attr_reader :subject, :verb, :object

  # As subject, verb and object are arrays of word pairs,
  # we only assign the second word of the pair to the variables.
  def initialize(subject, verb, object)
    @subject = subject[1]
    @verb = verb[1]
    @object = object[1]
  end
end

# Returns the type (first word) of the first word pair of word_list.
def peek(word_list)
  if word_list
    word_pair = word_list[0]
    word_pair[0]
  else
    nil
  end
end

# Shifts the first pair of word_list and stores it in word_pair.
# If the first word of word_pair is the same as expecting,
# returns word_pair.
def match(word_list, expecting)
  if word_list
    word_pair = word_list.shift

    if word_pair[0] == expecting
      word_pair
    else
      nil
    end
  else
    nil
  end
end

# Deletes the word pairs containing word_type in word_list.
# Normally we use this for deleting the stop words from the sentence.
def skip(word_list, word_type)
  word_list.delete_if { |a| a.include?(word_type) }
end

# We delete the stop words using the skip method.
# Then, if the type of the first word pair is 'verb',
# we use the match method on it. Else, we raise an error.
def parse_verb(word_list)
  skip(word_list, 'stop')

  if peek(word_list) == 'verb'
    match(word_list, 'verb')
  else
    raise ParserError.new("Expected a verb next.")
  end
end

# We delete the verbs and stop words using the skip method.
# Then we use the peek method to save the type of the next 
# word pair to next_word.
# If next_word is 'noun' or 'direction', we use it on the match method.
# Else, we raise an error.
def parse_object(word_list)
  skip(word_list, 'verb')
  skip(word_list, 'stop')
  next_word = peek(word_list)

  if next_word == 'noun'
    match(word_list, 'noun')
  elsif next_word == 'direction'
    match(word_list, 'direction')
  else
    raise ParserError.new("Expected a noun or direction next.")
  end
end

# We delete the stop words using the skip method.
# Then we use the peek method to save the type of the next 
# word pair to next_word.
# If next_word is 'noun', we use it on the match method.
# If next_word is 'verb', we return an array with 'player'
# as a 'noun' (we assume the subject is the player).
# Else, we raise an error.
def parse_subject(word_list)
  skip(word_list, 'stop')
  next_word = peek(word_list)

  if next_word == 'noun'
    match(word_list, 'noun')
  elsif next_word == 'verb'
    ['noun', 'player']
  else
    raise ParserError.new("Expected verb next.")
  end    
end

# We save the word pairs of subject, verb and object in the
# respective variables, and then we create a Sentence object with them.
def parse_sentence(word_list)
  subject = parse_subject(word_list)
  verb = parse_verb(word_list)
  object = parse_object(word_list)

  Sentence.new(subject, verb, object)
end