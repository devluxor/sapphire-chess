module CastlingBoardControl
  # (See Castling, movement.rb::CastlingPieceControl, Rook, King)
  def mark_moved_piece!(piece)
    return unless self[piece].is_a?(Rook) || self[piece].is_a?(King)

    self[piece].mark!
  end

  def castle!(side, color, permanent: false)
    castling_squares =
      if color == :white && side == :king then [[7, 4], [7, 6], [7, 7], [7, 5]]
      elsif color == :white && side == :queen then [[7, 4], [7, 2], [7, 0], [7, 3]]
      elsif color == :black && side == :king then [[0, 4], [0, 6], [0, 7], [0, 5]]
      else
        [[0, 4], [0, 2], [0, 0], [0, 3]]
      end

    king_start, king_target, rook_start, rook_target = castling_squares

    move_piece!(king_start, king_target, permanent: permanent)
    move_piece!(rook_start, rook_target, permanent: permanent)
  end

  def uncastle!(side, color)
    castling_squares =
      if color == :white && side == :king then [[7, 6], [7, 4], [7, 5], [7, 7]]
      elsif color == :white && side == :queen then [[7, 2], [7, 4], [7, 3], [7, 0]]
      elsif color == :black && side == :king then [[0, 6], [0, 4], [0, 5], [0, 7]]
      else
        [[0, 2], [0, 4], [0, 3], [0, 0]]
      end
    king_start, king_target, rook_start, rook_target = castling_squares

    move_piece!(king_start, king_target, permanent: false)
    move_piece!(rook_start, rook_target, permanent: false)
  end
end
