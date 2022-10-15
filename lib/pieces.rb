class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Pawn < Piece
  def to_s
    color == :white ? '♙' : '♟'
  end

  def move_directions
    [[0, 1]]
  end
end

class Rook < Piece
  def to_s
    color == :white ? '♖' : '♜'
  end

  def move_directions
    [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]
  end
end

class Knight < Piece
  def to_s
    color == :white ? '♘' : '♞'
  end

  def move_directions
    [
      [1, 2],
      [2, 1],
      [-1, 2],
      [-2, 1],
      [1, -2],
      [2, -1],
      [-1, -2],
      [-2, -1]
    ]
  end
end

class Bishop < Piece
  def to_s
    color == :white ? '♗' : '♝'
  end

  def move_directions
    [
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ]
  end
end

class Queen < Piece
  def to_s
    color == :white ? '♕' : '♛'
  end

  def move_directions
    [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0],
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ]
  end
end

class King < Piece
  def to_s
    color == :white ? '♔' : '♚'
  end

  def move_directions
    [
      [0, 1],
      [1, 1],
      [1, 0],
      [0, -1],
      [1, -1],
      [-1, 1],
      [-1, -1],
      [-1, 0]
    ]
  end
end



