module CastlingPieceControl
  def moved?
    @moved
  end

  def mark!
    @moved = true
  end
end
