class Board
  INITIAL_MARKER = ' '
  attr_accessor :squares
  
  def initialize
    squares = {}
    (1..9).each { |key| squares[key] = Square.new(INITIAL_MARKER)}
    @squares = squares
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
end

class Square
  attr_accessor :marker
  
  def initialize(marker)
    @marker = marker
  end
  
  def to_s
    @marker
  end

  def unmarked?
    marker == Board::INITIAL_MARKER
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
    board.set_square_at(board.unmarked_keys.sample, computer.marker)
  end
  
  def display_welcome_message
    puts "Welcome to Tictac Toe"
  end
  
  def display_goodbye_message
    puts "Thanks for playing Tictac Toe"
  end
  
  def display_board
    puts '________________________'
    puts '      |         |       '
    puts " #{board.get_square_at(1)}    |   #{board.get_square_at(2)}     |   #{board.get_square_at(3)}    "
    puts '      |         |       '
    puts '______+_________+_______'
    puts '      |         |       '
    puts " #{board.get_square_at(4)}    |   #{board.get_square_at(5)}     |   #{board.get_square_at(6)}    "
    puts '      |         |       '
    puts '______+_________+_______'
    puts '      |         |       '
    puts " #{board.get_square_at(7)}    |   #{board.get_square_at(8)}     |   #{board.get_square_at(9)}    "
    puts '      |         |       '
    puts '________________________'

  end
  
  def someone_won?
    false
  end
  
  def board_full?
    board.unmarked_keys.empty?
  end
  
  def display_result
    puts "nothing yet"
  end
  
  def play
    display_welcome_message
    display_board
    loop do
      human_moves
      display_board
      break if someone_won? || board_full?
      computer_moves
      display_board
       break if someone_won? || board_full?
    end
    display_result
    display_goodbye_message
  end
end

game = TTTGame.new
game.play


