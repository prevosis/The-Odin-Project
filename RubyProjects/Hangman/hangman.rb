require 'yaml'

def make_guess_word(word)
  guess_word = ''
  word.length.times do
    guess_word+='-'
  end
  guess_word
end

def guess_amt(guesses)
  if guesses > 1
    "You have #{guesses} guesses left"
  else
    "You have #{guesses} guess left"
  end
end

def check_guess(word, guess)
  word.include?guess
end

def update_guess_word(word, guess_word, guess)
  guess_word.length.times do |i|
    if word[i] == guess
      guess_word[i] = guess
    end
  end
  guess_word
end

def save_game(guesses, guess_word, word, guessed_letters)
  data = [guesses, guess_word, word, guessed_letters]
  save_data = YAML::dump(data)
  File.open('save_data.yaml', 'w') do |f|
    f.puts save_data
  end
end

def load_game
  File.open('save_data.yaml') {|yf| YAML::load(yf)}
end

puts %q{Welcome to command line Hangman! Your objective is to guess a word generated by the computer.
You have 8 guesses to correctly guess the word. Have fun!}

puts %q{Would you like to load a previous save file? Type 'yes' below if you would like to. Type any
other key if you would like to start a new game.}
input = gets.chomp.upcase

if input == 'YES'
  guesses = load_game[0]
  guess_word = load_game[1]
  word = load_game[2]
  guessed_letters = load_game[3]
else
  text = File.readlines('text.txt')
  dict = text.map {|line| line.chomp}.select {|line| line.length >= 5 && line.length <= 12 }

  word = dict[rand(dict.length)].downcase.chomp
  guess_word = make_guess_word(word)

  guesses = 8
  guessed_letters = []
end

victory = false

while guesses > 0 do
  puts guess_amt(guesses)
  puts "The word now looks like this: #{guess_word}"
  puts "You have guessed #{guessed_letters}"

  puts %q{Would you like to save the game? Type 'yes' if you would like to, otherwise type any other key.}
  input = gets.chomp.upcase
  if input == 'YES'
    save_game(guesses, guess_word, word, guessed_letters)
    exit
  end

  puts 'Enter your guess below: '
  guess = gets.chomp
  if check_guess(word, guess)
    guess_word = update_guess_word(word, guess_word, guess)
  else
    guessed_letters << guess
    guesses-=1
  end
  if guess_word == word
    puts 'You have guessed correctly!'
    victory = true
    break
  end
end

puts 'You have exceeded the amount of allowed guesses' unless victory
puts "The word was: #{word}"