class Code
    def initialize(code)
        @code = code
        @color_counts = Hash.new(0)
        code.each_char do |char|
            @color_counts[char] += 1
        end
    end
    
    def check_code(guess_code)
        guess = guess_code.chars
        result = []
        returned_is_in_code = ""
        returned_is_in_code_index = []
        guess.each_with_index do |guess_char, position|
            if is_correct?(guess_char,position)
                result[position] = "+"
                returned_is_in_code += guess_char
                returned_is_in_code_index.push(position)
            end
        end
        guess.each_with_index do |guess_char, position|
            if (is_in_code?(guess_char) && !returned_is_in_code_index.include?(position) &&
                (returned_is_in_code.count(guess_char) < @color_counts[guess_char]))
                result[position] = "?"
                returned_is_in_code += guess_char
            elsif !returned_is_in_code_index.include?(position)
                result[position] = "-"
            end
        end
        result.join("")
    end

    private
    def is_correct?(guess, position)
        @code[position] == guess
    end

    def is_in_code?(guess)
        @code.include?(guess)
    end
end

class Game
    def initialize
        @game_type = 0
        until @game_type == 1 || @game_type == 2
            puts "Do you want to play as the (1) codebreaker or (2) codemaker?"
            @game_type = gets.chomp.to_i
        end
        if @game_type == 1
            @code = Code.new(make_code)
        else
            @code = Code.new(get_code)
        end
    end

    def play
        if @game_type == 1
            play_as_codebreaker
        else
            play_as_codemaker
        end
    end

    private
    def make_code
        colors = ["G", "B", "P", "R", "O", "Y"]
        code = ""
        4.times do
            code += colors.sample
        end
        code
    end

    def get_code
        valid_input = false
        until valid_input
            valid_input = true
            valid_chars = "GBPROY"
            puts
            puts "(G)reen, (B)lue, (P)urple, (R)ed, (O)range, (Y)ellow"
            puts "Enter your code (case insensitive) with no spaces:"
            code = gets.chomp.upcase
            if code.length != 4
                valid_input = false
            end
            code.chars.each do |char|
                if !valid_chars.include?(char)
                    valid_input = false
                end
            end
        end
        code
    end

    def play_as_codebreaker
        game_won = false
        turn = 1
        until game_won || turn > 12
            guess_code = ""
            puts
            puts "Turn #{turn}"
            for position in 0..3 do
                guess = ""
                until guess == "G" || guess == "B" || guess == "P" || guess == "R" || guess == "O" || guess == "Y"
                    puts "(G)reen, (B)lue, (P)urple, (R)ed, (O)range, (Y)ellow"
                    puts "What is your (case insensitive) guess for position #{position}?"
                    guess = gets.chomp.upcase
                end
                guess_code += guess
            end
            result = @code.check_code(guess_code)
            puts
            puts "+ means your guess in a position is correct, ? means position is incorrect,"
            puts "Your guess was:  #{guess_code}"
            puts "The results are: #{result}"
            if result == "++++"
                game_won = true
            else
                turn += 1
            end
        end
        puts
        if game_won
            puts "You win! You used #{turn}/12 guesses."
        else
            puts "You ran out of guesses. The computer wins."
        end
    end

    def play_as_codemaker
        game_won = false
        turn = 1
        known_positions = ["", "", "", ""]
        unknown_positions = []
        colors = ["G", "B", "P", "R", "O", "Y"]
        previous_guesses = Hash.new {|key, value| key[value]=[]}
        until game_won || turn > 12
            guess_code = ""
            puts
            puts "Turn #{turn}"
            for position in 0..3 do
                if known_positions[position] != ""
                    guess_code += known_positions[position]
                elsif unknown_positions.length > 0
                    good_move = false
                    attempts = 0
                    until good_move || attempts == 10
                        good_move = true
                        guess_char = unknown_positions.sample
                        if previous_guesses[position].include?(guess_char)
                            good_move = false
                            attempts += 1
                        else
                            unknown_positions.delete(guess_char)
                        end
                    end
                    guess_code += guess_char
                else
                    good_move = false
                    until good_move
                        good_move = true
                        guess_char = colors.sample
                        if previous_guesses[position].include?(guess_char)
                            good_move = false
                        end
                    end
                    guess_code += guess_char
                end
            end
            result = @code.check_code(guess_code)
            puts
            puts "+ means computer's guess in a position is correct, ? means position is incorrect"
            puts "The computer's guess was: #{guess_code}"
            puts "The results are:          #{result}"
            if result == "++++"
                game_won = true
            else
                turn += 1
                result.chars.each_with_index do |char, position|
                    if char == "+"
                        known_positions[position] = guess_code[position]
                        unknown_positions.delete(guess_code[position])
                    end
                end
                result.chars.each_with_index do |char, position|
                    if char == "?"
                        unknown_positions.push(guess_code[position])
                        previous_guesses[position].push(guess_code[position])
                    elsif char == "-"
                        previous_guesses[position].push(guess_code[position])
                    end
                end
                print previous_guesses
                puts
                puts "Press Enter to continue."
                gets
            end
        end
        if game_won
            puts "You lose! The computer used #{turn}/12 guesses."
        else
            puts "The computer ran out of guesses. You win!"
        end
    end
end

game = Game.new
game.play