require_relative 'board.rb'

class Game
  attr_reader :player_1, :player_2, :board, :renderer
  attr_accessor :current_player

  def initialize(board, player_1, player_2, renderer_class)
    @board = board
    @renderer = renderer_class.new(board)
    @player_1 = player_1
    @player_2 = player_2
    @current_player = player_1
  end

  def swap_player!
    self.current_player = (current_player == player_1 ? player_2 : player_1)
  end

  def play
    loop do
      system 'clear'
      renderer.render
      puts "It's #{current_player.color}'s turn!"
      start_position = nil
      end_position = nil
      loop do
        puts 'Select piece position to move:'
        start_position = current_player.get_position
        break if board[start_position].color == current_player.color
        puts "Please, select a #{current_player.color} piece."
      end
      
      loop do 
        puts 'Select end position:'
        end_position = current_player.get_position
        break if board[start_position].available_moves.include?(end_position)
        puts "Please, select a valid end position."
      end

      board[end_position] = board[start_position]
      board[start_position] = Board::EMPTY_SQUARE

      swap_player!
    end
  end
end