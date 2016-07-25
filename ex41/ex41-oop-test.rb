require 'open-uri'

# List of words to use.
WORD_URL = "http://learncodethehardway.org/words.txt"

# Empty array.
WORDS = []

# Hash with phrases to use. We are going to use regex to replace ###, @@@, and ***.
PHRASES = {
	"class ### < ###\nend" =>
		"Make a class named ### that is-a ###.",
	"class ###\n\tdef initialize(@@@)\n\tend\nend" =>
		"class ### has-a initialize that takes @@@ parameters.",
	"class ###\n\tdef ***(@@@)\n\tend\nend" =>
		"class ### has-a function named *** that takes @@@ parameters.",
	"*** = ###.new" =>
		"Set *** to an instance of class ###.",
	"***.***(@@@)" =>
		"From *** get the *** function, and call it with parameters @@@.",
	"***.*** = '***'" =>
		"From *** get the *** attribute and set it to '***'."
}

# Sets PHRASE_FIRST to true if we write "english" after "ruby oop_test.rb".
PHRASE_FIRST = ARGV[0] == "english"

# Open the document containing the words, and push each line (there is only one word per line) to the WORDS array.
# That way we are going to have all the words of the document stored in out array WORDS.
open(WORD_URL) do |f|
	f.each_line { |word| WORDS << word.chomp }
end

def craft_names(rand_words, snippet, pattern, caps=false)
	# Scan the snippet (phrase) for the pattern (###, @@@, ***) and return an array (.map), using the "names" variable.
	names = snippet.scan(pattern).map do
		# Each time it finds the patttern, it pops (.pop) a random word from the WORDS array and stores it in the "word" variable.
		word = rand_words.pop
		# If caps is set to true, it capitalizes the word.
		caps ? word.capitalize : word
	end

	# Return the names array multiplied by 2.
	names * 2
end

def craft_params(rand_words, snippet, pattern)
	# Sets an iterator between 0 and the length of the pattern (@@@). 3 in this case, so (0...3).
	names = (0...snippet.scan(pattern).length).map do
		# Generates a random number between 1 and 3 (that's why we add 1 to rand(3), otherwise rand(3)
		# would return a number between 0 and 2), and store it in the param_count variable.
		param_count = rand(3) + 1
		# Create an array with a random number of items between 0 and param_count (random number
		# between 1 and 3), with random words from the WORDS array, and store it in the "params" variable.
		params = (0...param_count).map { |x| rand_words.pop }
		# Convert array to string, joining the items with a comma in between.
		params.join(', ')
	end

	# Return the names array multiplied by 2.
	names * 2
end

def convert(snippet, phrase)
	# Store random words from the "WORDS" array in the "rand_words" variable.
	rand_words = WORDS.sort_by { rand }
	# Create class names using the "craft_names" function, and store the result in the "class_names" variable.
	# Here we set "caps" to "true" because class names use caps.
	class_names = craft_names(rand_words, snippet, /###/, caps=true)
	# Create other names (mainly for functions and variables), and store the result in the "other_names" variable.
	other_names = craft_names(rand_words, snippet, /\*\*\*/)
	# Create parameters using the "craft_params" function, and store the result in the "param_names" variable.
	param_names = craft_params(rand_words, snippet, /@@@/)

	# Create an empty "results" array.
	results = []

	# Iterate over the snippet and then phrase.
	[snippet, phrase].each do |sentence|
		# Substitute every ### in the sentence for a class name, and store it in the "result" variable.
		result = sentence.gsub(/###/) { |x| class_names.pop }

		# Take that same sentence and substitute every \*\*\* for another name, and store the result using "!".
		result.gsub!(/\*\*\*/) { |x| other_names.pop }

		# Take that same sentence and substitute every @@@ for parameters.
		result.gsub!(/@@@/) { |x| param_names.pop }

		# Store that new sentence, with class names and other names, into the "results" array.
		results << result
	end

		# Return "results" array.
		results
end

# Keep going until they hit CTRL-D.
loop do
	# Sort randomly the keys from the "PHRASES" hash and store them into the "snippets" variable (array).
	snippets = PHRASES.keys.sort_by { rand }

	# Iterate over the "snippets" array.
	snippets.each do |snippet|
		# Store every value of the "PHRASES" hash in the "phrase" variable.
		phrase = PHRASES[snippet]
		# Use the function "convert" with "|snippet|" and the "phrase" variable, to create "question" and "answer".
		question, answer = convert(snippet, phrase)

		# Check if "PHRASE_FIRST" is set to true. In that case, change the order from "question, answer" (code to english),
		# to "answer, question" (english to code).
		if PHRASE_FIRST
			question, answer = answer, question
		end

		# Print question.
		print question, "\n\n> "

		exit(0) unless $stdin.gets

		# Puts answer.
		puts "\nANSWER:  %s\n\n" % answer
	end
end