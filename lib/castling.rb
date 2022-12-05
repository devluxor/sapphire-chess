module CastlingRights
  # To be used by Player class:
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

    return true unless board[king].is_a?(King) && board[rook].is_a?(Rook)

    board[king].moved? && board[rook].moved?
  end

  def castling_line_free?(side)
    case color
    when :white
      if side == :king
        board.empty_square?([7, 5]) && 
          board.empty_square?([7, 6])
      else
        board.empty_square?([7, 1]) && 
          board.empty_square?([7, 2]) &&
          board.empty_square?([7, 3])
      end
    else
      if side == :king
        board.empty_square?([0, 5]) && 
          board.empty_square?([0, 6])
      else
        board.empty_square?([0, 1]) && 
          board.empty_square?([0, 2]) &&
          board.empty_square?([0, 3])
      end
    end
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

module CastlingPieceControl
  def moved?
    @moved
  end

  def mark!
    @moved = true
  end
end

module CastlingBoardControl
  # To be used in Board class:

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
end
