require_relative 'board.rb'
require 'pry'

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

  
  def play
    loop do
      break if over?
      
      system 'clear'
      
      renderer.render
      
      puts "It's #{current_player.color}'s turn!"
      puts 'You are in check!' if board.in_check?(current_player.color)
      
      turn
      
      swap_player!
    end
    
    puts 'End'
  end
  
  def swap_player!
    self.current_player = (current_player == player_1 ? player_2 : player_1)
  end

  def turn
    start_position = nil
    end_position = nil

    # TODO: 
    # Indicate piece selected
    loop do
      puts "What piece do you want to move?"
      start_position = current_player.get_position
      break if !board[start_position].is_a?(NullPiece) && 
        board[start_position].color == current_player.color 
      puts "Please, select a #{current_player.color} piece."
    end
    
    loop do
      puts "Where do you want to move the #{board[start_position].class}?"
      end_position = current_player.get_position
      break if board[start_position].available_moves.include?(end_position)
      puts "The piece selected can't move to that square."
    end

    board.move_piece!(start_position, end_position)
  end

  def over?
    board.checkmate?(current_player.color)
  end
end