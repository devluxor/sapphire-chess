require_relative '../pieces'
require_relative '../movement_rules/castling_board_control'
require_relative '../movement_rules/en_passant_board_control'
require_relative '../board'

class Board
  SQUARE_ORDER = 8
  B_PAWN_ROW = 1
  W_PAWN_ROW = 6
  FIRST_ROW = 0
  LAST_ROW = 7
  PIECES_SEQUENCE = [
    Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
  ].freeze

  include BoardAnalysis
  include BoardEvaluation
  include ProvisionalMoves
  include CastlingBoardControl
  include EnPassantBoardControl

  attr_reader :matrix, :white_player, :black_player, :hard_difficulty

  def self.initialize_board
    board = new(duplicated: false)

    set_pawns(board)
    set_pieces(board)

    board
  end

  class << self
    private

    def set_pawns(board)
      [B_PAWN_ROW, W_PAWN_ROW].each do |pawn_row|
        color = pawn_row == B_PAWN_ROW ? :black : :white
  
        SQUARE_ORDER.times do |column|
          board[[pawn_row, column]] = Pawn.new(board, [pawn_row, column], color)
        end
      end
    end

    def set_pieces(board)
      [[FIRST_ROW, :black], [LAST_ROW, :white]].each do |(row, color)|
        PIECES_SEQUENCE.each_with_index do |piece, column|
          board[[row, column]] = piece.new(board, [row, column], color)
        end
      end
    end
  end

  def initialize(duplicated: false)
    @matrix = Array.new(SQUARE_ORDER) { Array.new(SQUARE_ORDER, EmptySquare.instance) }
    @duplicated = duplicated
  end

  def add_players!(player1, player2)
    if player1.color == :white
      @white_player = player1
      @black_player = player2
    else
      @white_player = player2
      @black_player = player1
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
    square.none? { |axis| axis >= SQUARE_ORDER || axis.negative? }
  end

  def empty_square?(square)
    row, column = square
    within_limits?(square) && matrix[row][column].is_a?(EmptySquare)
  end

  def move_piece!(piece, target_square, permanent: false)
    mark_moved_piece!(piece) if permanent

    self[piece], self[target_square] = EmptySquare.instance, self[piece]

    self[target_square].location = target_square

    return unless permanent && was_en_passant?(piece, target_square)
    
    capture_passed_pawn!(target_square)
  end

  # Deep duplication of the board for Piece#safe_moves
  def duplicate
    pieces.each_with_object(Board.new(duplicated: true)) do |piece, new_board|
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
  def a_duplicate?
    @duplicated
  end

  def set_game_difficulty
    self.hard_difficulty =
      [white_player, black_player].find do |player|
        player.is_a?(Computer)
      end.depth == 3
  end

  def hard_difficulty?
    hard_difficulty
  end

  private

  attr_writer :hard_difficulty
end
