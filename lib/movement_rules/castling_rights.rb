module CastlingRights
  def castle_rights?(side)
    !king_and_rook_moved?(side) &&
      castling_line_free?(side) &&
      !board.in_check?(color) &&
      !results_in_check?(side) &&
      !king_crosses_attack_line?(side)
  end

  private

  def king_and_rook_moved?(side)
    case color
    when :white
      king = [7, 4]
      rook = side == :king ? [7, 7] : [7, 0]
    else
      king = [0, 4]
      rook = side == :king ? [0, 7] : [0, 0]
    end

    return true unless board[king].is_a?(King) && board[rook].is_a?(Rook)

    board[king].moved? && board[rook].moved?
  end

  def castling_line_free?(side)
    if color == :white && side == :king then f1_to_g1_free?
    elsif color == :white && side == :queen then b1_to_d1_free?
    elsif color == :black && side == :king then f8_to_g8_free?
    else 
      b8_to_d8_free?
    end
  end

  def f1_to_g1_free?
    board.empty_square?([7, 5]) &&
      board.empty_square?([7, 6])
  end

  def b1_to_d1_free?
    board.empty_square?([7, 1]) &&
      board.empty_square?([7, 2]) &&
      board.empty_square?([7, 3])
  end

  def f8_to_g8_free?
    board.empty_square?([0, 5]) &&
      board.empty_square?([0, 6])
  end

  def b8_to_d8_free?
    board.empty_square?([0, 1]) &&
      board.empty_square?([0, 2]) &&
      board.empty_square?([0, 3])
  end

  def results_in_check?(side)
    return true if king_and_rook_moved?(side)
    board.castle!(side, color)
    in_check = board.in_check?(color)
    board.uncastle!(side, color)

    in_check
  end

  def king_crosses_attack_line?(side)
    hot_square = case color
                 when :white then side == :king ? [7, 5] : [7, 3]
                 else side == :king ? [0, 5] : [0, 3]
                 end

    board.enemy_pieces(color).each do |piece|
      return true if piece.available_moves.include?(hot_square)
    end

    false
  end
end
