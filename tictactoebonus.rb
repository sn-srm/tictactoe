require 'pry'

class Board
  WINNING_PAIRS = [[1, 2, 3],
                  [4, 5, 6],
                  [7, 8, 9],
                  [1, 4, 7],
                  [2, 5, 8],
                  [3, 6, 9],
                  [1, 5, 9],
                  [3, 5, 7]
                  ].freeze
  attr_accessor :squares
  
  def initialize
    squares = {}
    @squares = squares
    reset
  end

  def draw
    puts '________________________'
    puts '      |         |       '
    puts " #{get_square_at(1)}    |   #{get_square_at(2)}     |   #{get_square_at(3)}    "
    puts '      |         |       '
    puts '______+_________+_______'
    puts '      |         |       '
    puts " #{get_square_at(4)}    |   #{get_square_at(5)}     |   #{get_square_at(6)}    "
    puts '      |         |       '
    puts '______+_________+_______'
    puts '      |         |       '
    puts " #{get_square_at(7)}    |   #{get_square_at(8)}     |   #{get_square_at(9)}    "
    puts '      |         |       '
    puts '________________________'

  end

  def reset
    (1..9).each { |key| squares[key] = Square.new }
  end
  
  def get_square_at(square)
    @squares[square]
  end
  
  def set_square_at(key, marker)
    @squares[key].marker = marker
  end
  
  def unmarked_keys
    squares.select {|k,v| v.unmarked?}.keys
  end

  def someone_won
    !!winning_marker
  end

  def count_human_markers(squares)
    squares.select{|square| square.marker == TTTGame::HUMAN_MARKER }.count
  end

  def count_computer_markers(squares)
    squares.select{|square| square.marker == TTTGame::COMPUTER_MARKER }.count
  end
  
  #renamed from detect_round_winner 
  def winning_marker
    WINNING_PAIRS.each do |line|
      squares_on_line = @squares.values_at(*line)
      if count_human_markers(squares_on_line) == 3 
        return TTTGame::HUMAN_MARKER
      elsif count_computer_markers(squares_on_line) == 3
        return TTTGame::COMPUTER_MARKER
      end           
    end
    nil
end
  
end

class Square
  INITIAL_MARKER = ' '
  attr_accessor :marker
  
  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end
  
  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end


class Player
  attr_reader :marker
  
  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "0"
  attr_accessor :board, :human, :computer
  
  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end
  
  def human_moves
    puts "Choose any of the following: #{board.unmarked_keys.join(', ')}"
    human_square = ''
    loop do
      human_square = gets.chomp.to_i
      break if board.unmarked_keys.include?(human_square)
      puts "not a valid choice"
    end
    board.set_square_at(human_square, human.marker)
  end
  
  def computer_moves
    puts "Computer's turn.........."
    pause
    clear
    board.set_square_at(board.unmarked_keys.sample, computer.marker)
  end
  
  def display_welcome_message
    puts "Welcome to Tictac Toe"
  end
  
  def display_goodbye_message
    puts "Thanks for playing Tictac Toe"
  end

  def clear
    system "clear"
  end

  def pause
    sleep(2.0)
  end
  
  def clear_screen_and_display_board
    clear
    display_board
  end
  
  def display_board
    board.draw
  end
  
  def someone_won?
    !!board.winning_marker
  end
  
  def board_full?
    board.unmarked_keys.empty?
  end
  
  def display_result
    # display_board
    case board.winning_marker
      when HUMAN_MARKER
        puts "You won!"
      when COMPUTER_MARKER
        puts "Computer won!"
      else
        puts "The board is full"
    end
  end

  def play_again?
    answer = ''
    loop do
      puts "Do you want to play again? Enter 'y' or 'n"
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Please enter 'y' or 'n'"
    end
    return true if answer ==  'y'
  end

  def reset_game
    clear
    board.reset
  end

  def display_reset_message
    puts "Playing again!"
  end
  
  def play
    display_welcome_message
    loop do
      display_board
      loop do
        human_moves
        clear_screen_and_display_board
        break if someone_won? || board_full?
        computer_moves
        clear_screen_and_display_board
         break if someone_won? || board_full?
      end
      display_result
      break unless play_again?
      reset_game
      display_reset_message
    end
    display_goodbye_message
  end
end

game = TTTGame.new
game.play


