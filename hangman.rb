require 'yaml'

class Word
    attr_reader :word

    def initialize(word = "")
        if word == ""
            dictionary = File.open("5desk.txt", "r")
            until word.length >= 5 && word.length <= 12
                word = File.readlines(dictionary).sample.chomp
            end
            dictionary.close
        end
        @word = word
    end

    def get_letter_positions(letter)
        @word.length.times.find_all { |char| @word[char].downcase == letter }
    end
end

class Game
    def initialize
        new_game = true
        if File.exist? "hangman.yml"
            response = ""
            until response == "L" or response == "S"
                puts "A save file exists. (L)oad it, or (S)tart a new game?"
                response = gets.chomp.upcase
            end
            new_game = false if response == "L"
        end
        if new_game
            @word = Word.new
            @guesses_remaining = 6
            @previous_guesses = []
            @displayed_word = ""
            @word.word.length.times { @displayed_word += "_" }
        else
            load
        end
    end

    def play
        while @displayed_word.include?("_") && @guesses_remaining > 0
            guesses = ""
            puts
            puts @displayed_word
            puts
            puts "Guesses remaining: #{@guesses_remaining}"
            puts "Previous guesses:"
            @previous_guesses.each { |char| guesses += "#{char} "}
            puts guesses
            input = ""
            until input == "G" || input == "S"
                puts "Do you want to (G)uess or (S)ave and quit?"
                input = gets.chomp.upcase
            end
            if input == "S"
                if File.exist? "hangman.yml"
                    until input == "O" || input == "Q"
                        puts "A saved game already exists. (O)verwrite, or (Q)uit without saving?"
                        input = gets.chomp.upcase
                    end
                    if input == "Q"
                        exit
                    end
                end
                save
                puts "Game saved."
                exit
            end
            guess = ""
            until guess.length == 1 && guess.count("a-z") == 1
                puts
                puts "What is your guess?"
                guess = gets.chomp.downcase
            end
            puts
            if @word.word.include?(guess)
                letter_positions = @word.get_letter_positions(guess)
                letter_positions.each { |index| @displayed_word[index] = guess }
            else
                puts "The letter '#{guess}' is not in the word."
                @guesses_remaining -= 1
                @previous_guesses.push(guess)
                @previous_guesses.sort!
            end
        end
        puts
        if @guesses_remaining == 0
            puts "You ran out of guesses. The computer wins. The word was '#{@word.word}'"
        else
            puts "The word is '#{@displayed_word}'. You win!"
        end
    end

    private
    def save
        save_data = { word: @word.word,
                    guesses_remaining: @guesses_remaining,
                    previous_guesses: @previous_guesses,
                    displayed_word: @displayed_word }
        save_file = File.open("hangman.yml", "w") { |file| file.write(save_data.to_yaml)}
    end

    def load
        save_data = YAML.load(File.read("hangman.yml"))
        @word = Word.new(save_data[:word])
        @guesses_remaining = save_data[:guesses_remaining]
        @previous_guesses = save_data[:previous_guesses]
        @displayed_word = save_data[:displayed_word]
    end
end
game = Game.new
game.play