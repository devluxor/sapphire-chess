module BoardAnalysis
  def in_check?(color)
    king_position = find_king(color)
    
    enemy_pieces(color).each do |piece|
      return true if piece.available_moves.include?(king_position)
    end
    
    false
  end

  def find_king(color)
    king_location = pieces.find { |piece| piece.color == color && piece.is_a?(King) }

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
    grid.flatten.reject { |position| position.is_a?(NullPiece) }
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
    friendly_pieces(Pawn).select do |piece| 
      piece.class == Pawn && piece.promoted?
    end.size
  end
end