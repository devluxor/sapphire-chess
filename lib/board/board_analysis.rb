module BoardAnalysis
  # This is the total material evaluation (pieces value put together) 
  # when a player keeps just a king, a queen and a few pieces:
  LAST_STAND_PIECES_VALUE = 21500

  def in_check?(color)
    king_position = find_king(color)

    enemy_pieces(color).each do |piece|
      return true if piece.available_moves.include?(king_position)
    end

    false
  end

  def find_king(color)
    king_location = pieces.find do |piece|
      piece.color == color && piece.is_a?(King)
    end

    king_location ? king_location.location : nil
  end

  def checkmate?(color)
    return false unless in_check?(color)

    friendly_pieces(color).all? { |piece| piece.safe_moves.empty? }
  end

  def no_king?(color)
    find_king(color).nil?
  end

  def pieces
    matrix.flatten.reject { |position| position.is_a?(EmptySquare) }
  end

  def friendly_pieces(color)
    pieces.select { |piece| piece.color == color }
  end

  def enemy_pieces(color)
    pieces.select { |piece| piece.color != color }
  end

  def count(type, color)
    friendly_pieces(color).select { |piece| piece.class == type }.size
  end

  def promoted_pawns(color)
    friendly_pieces(color).select do |piece|
      piece.is_a?(Pawn) && piece.promoted?
    end.size
  end

  def end_game?
    (count(Queen, :white).zero? && count(Queen, :black).zero?) ||
      (last_stand?(:white) || last_stand?(:black))
  end

  def last_stand?(color)
    count(Queen, color).positive? && 
      friendly_pieces(color).map(&:value).sum <= LAST_STAND_PIECES_VALUE
  end
end
