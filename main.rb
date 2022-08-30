# Mastermind
# 1. 12 rounds will be played
# 2. One player is the codemaker, one is the codebreaker.
# 3. The codemaker chooses a pattern of four code pegs.
# 4. Duplicates are allowed, but blanks are not
# 5. The codebreaker has to guess the correct combination both in color and
#    order in the given amount of time.
# 6. The codemaker places a black peg if the color and position is correct, 
#    and a white peg if only the color is correct. 

# The computer can be either a code breaker, or code maker.
class Computer

  def make_code(human, computer)
    @human = human
    @computer = computer
    @code_array = [(1 + rand(6)), (1 + rand(6)), (1 + rand(6)), (1 + rand(6))]
    @code = @code_array.join
    @human.enter_guess(@computer)
  end

  def check_if_win(players_guess)
    @guess_array = players_guess.to_s.split('')
    @guess = @guess_array.map { |val| val.to_i }
    if @guess == @code_array
      puts 'Human wins.'
    else check_guess
    end
  end

  def check_guess
    @display = Display.new(@guess)
    @already_checked = []
    i = 0
    while i < 4
      if @guess[i] == @code_array[i]
        @display.hint('X')
      elsif @code_array.any? { |val| val == @guess[i] } && @already_checked.none? { |val| val == @guess[i] }
        @display.hint('O')
        @already_checked.push(@guess[i])
      else @display.hint(' ')
      end
      i += 1
    end
    @display.show_guess_hint
    @human.enter_guess(@computer)
  end
end

class Display
  def initialize(players_guess)
    @players_guess = players_guess
    @hint_array = []
  end

  def hint(str = '')
    @hint_array.push(str)
    @hint_array.sort!
    @hint = @hint_array.join
  end

  def show_guess_hint
    puts "#{@players_guess}       #{@hint}"
  end
end

class Human

  def enter_guess(computer)
    @computer = computer
    puts "Enter 4 digits for your guess."
    @guess = gets.chomp.to_i
    if @guess.to_s.length != 4
      puts "Your guess must be 4 digits long."
      enter_guess(@computer)
    end
    @computer.check_if_win(@guess)
  end
end

class Game
  attr_reader :human, :computer
  attr_accessor :turns

  def initialize
    @turns = 0
    @human = Human.new
    @computer = Computer.new
  end

  def start
    puts "Welcome to Mastermind. enter '1' you want to be the codebreaker, or '2' codemaker."
    @player_choice = gets.to_i
    choice
  end

  def choice
    if @player_choice == 1
      @computer.make_code(@human, @computer)
    elsif @player_choice == 2
      @human.make_code
      @computer.guess_code
    elsif @player_choice != (1 || 2)
      puts 'Please enter either 1 or 2.'
      start
    end
  end
end

new_game = Game.new
new_game.start