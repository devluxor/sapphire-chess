require_relative '../pieces.rb'
require_relative 'board_renderer.rb'
require_relative 'board_analysis.rb'
require_relative 'board_evaluation.rb'

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

  attr_reader :grid, :renderer

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

  def initialize
    @grid = Array.new(SQUARE_ORDER) { Array.new(SQUARE_ORDER, NullPiece.instance) }
  end

  def [](location)
    row, column = location
    grid[row][column]
  end

  def []=(location, piece)
    row, column = location
    grid[row][column] = piece
  end

  def in_bounds?(location)
    location.none? { |axis| axis >= SQUARE_ORDER || axis < 0 }
  end

  def empty_square?(location)
    row, column = location
    in_bounds?(location) && grid[row][column].is_a?(NullPiece)
  end

  def move_piece!(piece, target_square, permanent=false)
    mark_moved_piece!(piece) if permanent

    self[piece], self[target_square] = NullPiece.instance, self[piece]

    begin
      self[target_square].location = target_square
    rescue NoMethodError => e
      puts "Board#Move_piece! tried to move a #{self[piece].class} "\
           "to #{target_square}."
      puts "Backtrace: #{e.backtrace}"
    end
  end

  # Controls castling rights 
  # (See Castling, movement.rb::CastlingPieceControl, Rook, King)
  def mark_moved_piece!(piece)
    return unless self[piece].is_a?(Rook) || self[piece].is_a?(King)

    self[piece].mark!
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
    pieces.each_with_object(Board.new) do |piece, new_board|
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
end
