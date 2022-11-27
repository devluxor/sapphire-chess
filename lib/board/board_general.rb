require_relative '../pieces.rb'
require_relative 'board_renderer.rb'
require_relative 'board_analysis.rb'
require_relative 'board_evaluation.rb'

require 'pry'

class Board
  SQUARE_ORDER = 8
  B_PAWN_ROW = 1
  W_PAWN_ROW = 6
  FIRST_ROW = 0
  LAST_ROW = 7
  PIECES_SEQUENCE = [
    Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
  ]

  include BoardAnalysis
  include BoardEvaluation

  attr_reader :matrix, :duplicate, :renderer, :white_player, :black_player

  def self.initialize_board
    board = new

    [B_PAWN_ROW, W_PAWN_ROW].each do |pawn_row|
      color = pawn_row == B_PAWN_ROW ? :black : :white

      SQUARE_ORDER.times do |column|
        board[[pawn_row, column]] = Pawn.new(board, [pawn_row, column], color)
      end
    end

    [[FIRST_ROW, :black], [LAST_ROW, :white]].each do |(row, color)|
      PIECES_SEQUENCE.each_with_index do |piece, column|
        board[[row, column]] = piece.new(board, [row, column], color)
      end
    end

    board
  end

  def initialize(duplicated=false)
    @matrix = Array.new(SQUARE_ORDER) { Array.new(SQUARE_ORDER, NoPiece.instance) }
    @duplicated = duplicated
  end

  def add_players!(player_1, player_2)
    if player_1.color == :white
      @white_player = player_1
      @black_player = player_2
    else
      @white_player = player_2
      @black_player = player_1
    end
  end

  def [](square)
    row, column = square
    matrix[row][column]
  end

  def []=(square, piece)
    row, column = square
    matrix[row][column] = piece
  end

  def within_limits?(square)
    square.none? { |axis| axis >= SQUARE_ORDER || axis < 0 }
  end

  def empty_square?(square)
    row, column = square
    within_limits?(square) && matrix[row][column].is_a?(NoPiece)
  end

  def move_piece!(piece, target_square, permanent=false)
    mark_moved_piece!(piece) if permanent

    self[piece], self[target_square] = NoPiece.instance, self[piece]

    self[target_square].location = target_square
    
    capture_passed_pawn(target_square) if was_en_passant?(piece, target_square)
  end

  # Controls castling rights 
  # (See Castling, movement.rb::CastlingPieceControl, Rook, King)
  def mark_moved_piece!(piece)
    return unless self[piece].is_a?(Rook) || self[piece].is_a?(King)

    self[piece].mark!
  end

  def capture_passed_pawn(target_square)
    passed_pawn = [target_square.first + 1, target_square.last]
    self[passed_pawn] = NoPiece.instance
  end

  def was_en_passant?(piece, target_square)
    passed_pawn = [target_square.first + 1, target_square.last]
    
    self[target_square].is_a?(Pawn) &&
      self[target_square].pawn_to_pass(piece).include?(passed_pawn)
  end

  def castle!(side, color, permanent=false)
    case color
    when :white
      if side == :king
        move_piece!([7, 4], [7, 6], permanent)
        move_piece!([7, 7], [7, 5], permanent)
      else
        move_piece!([7, 4], [7, 2], permanent)
        move_piece!([7, 0], [7, 3], permanent)
      end
    else
      if side == :king
        move_piece!([0, 4], [0, 6], permanent)
        move_piece!([0, 7], [0, 5], permanent)
      else
        move_piece!([0, 4], [0, 2], permanent)
        move_piece!([0, 0], [0, 3], permanent)
      end
    end
  end

  def uncastle!(side, color)
    case color
    when :white
      if side == :king
        move_piece!([7, 6], [7, 4])
        move_piece!([7, 5], [7, 7])
      else
        move_piece!([7, 2], [7, 4])
        move_piece!([7, 3], [7, 0])
      end
    else
      if side == :king
        move_piece!([0, 6], [0, 4])
        move_piece!([0, 5], [0, 7])
      else
        move_piece!([0, 2], [0, 4])
        move_piece!([0, 3], [0, 0])
      end
    end
  end

  # Deep duplication of the board for Piece#safe_moves
  def duplicate
    pieces.each_with_object(Board.new(true)) do |piece, new_board|
      new_piece = piece.class.new(new_board, piece.location, piece.color)

      new_board[new_piece.location] = new_piece
    end
  end

  def generate_moves(color)
    friendly_pieces(color).each_with_object([]) do |piece, possible_moves|
      location = piece.location

      piece.available_moves.each do |possible_move|
        possible_moves << [location, possible_move]
      end
    end
  end

  # This method is avoids checking for availability of en passant
  # moves in duplicate boards
  def is_a_duplicate?
    @duplicated
  end
end
