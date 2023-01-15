module EnPassantBoardControl
  def capture_passed_pawn!(target_square)
    captured_pawn = passed_pawn(target_square)

    self[captured_pawn] = EmptySquare.instance
  end

  def was_en_passant?(piece, target_square)
    captured_pawn = passed_pawn(target_square)

    self[target_square].is_a?(Pawn) &&
      self[target_square].pawn_to_pass(piece).include?(captured_pawn)
  end

  def passed_pawn(target_square)
    direction = self[target_square].color == :white ? 1 : -1

    [target_square.first + direction, target_square.last]
  end
end
