module Castling
  def castle_rights?(side)
    !king_and_rook_moved?(side) &&
      castling_line_free?(side) &&
      !board.in_check?(color) &&
      !results_in_check?(side) &&
      !king_crosses_attack_line?(side)
  end

  def king_and_rook_moved?(side)
    case color
    when :white
      king = [7, 4]
      rook = side == :king ? [7, 7] : [7, 0]
    else
      king = [0, 4]
      rook = side == :king ? [0, 7] : [0, 0]
    end

    board[king].is_a?(King) && board[king].moved? &&
      board[rook].is_a?(Rook) && board[rook].moved?
  end

  def castling_line_free?(side)
    case color
    when :white
      if side == :king
        board.empty_square?([7, 5]) && board.empty_square?([7, 6])
      else
        board.empty_square?([7, 1]) && board.empty_square?([7, 2]) &&
          board.empty_square?([7, 3])
      end
    else
      if side == :king
        board.empty_square?([0, 5]) && board.empty_square?([0, 6])
      else
        board.empty_square?([0, 1]) && board.empty_square?([0, 2]) &&
          board.empty_square?([0, 3])
      end
    end
  end

  def results_in_check?(side)
    board.castle!(side, color)
    in_check = board.in_check?(color)
    board.uncastle!(side, color)

    in_check
  end

  def king_crosses_attack_line?(side)
    hot_square = case color
                 when :white
                   if side == :king then [7, 5]
                   else [7, 3]
                   end
                 else
                   if side == :king then [0, 5]
                   else [0, 3]
                   end
                 end

    board.enemy_pieces(color).each do |piece|
      return true if piece.available_moves.include?(hot_square)
    end

    false
  end
end
