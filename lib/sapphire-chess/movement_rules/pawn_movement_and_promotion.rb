module PawnMovementAndPromotion
  def available_moves
    if promoted? then SlidePattern::available_moves
    else
      moves = []
      add_one_square_movement!(moves)
      add_two_square_movement!(moves)
      add_diagonal_movement!(moves)
      add_en_passant_movement!(moves)

      moves.select { |move| board.within_limits?(move) }
    end
  end

  def promoted?
    @promoted
  end

  private

  attr_writer :promoted

  def promote
    self.promoted = true if location.first == opposite_row
  end

  def opposite_row
    case color
    when :white then self.class::W_OPPOSITE_ROW
    else self.class::B_OPPOSITE_ROW
    end
  end

  def at_start?
    start_row = (color == :white ? Board::W_PAWN_ROW : Board::B_PAWN_ROW)

    current_row == start_row
  end

  def forward_direction
    color == :white ? -1 : 1
  end

  def add_one_square_movement!(moves)
    current_row, current_column = location

    one_forward = [current_row + forward_direction, current_column]
    moves << one_forward if board.empty_square?(one_forward)
  end

  def add_two_square_movement!(moves)
    current_row, current_column = location

    one_forward = [current_row + forward_direction, current_column]
    two_forward = [current_row + (forward_direction * 2), current_column]
    if board.empty_square?(two_forward) &&
       board.empty_square?(one_forward) &&
       at_start?
      moves << two_forward
    end
  end

  def add_diagonal_movement!(moves)
    current_row, current_column = location

    diagonal_left = [current_row + forward_direction, current_column + 1]
    diagonal_right = [current_row + forward_direction, current_column - 1]
    moves << diagonal_left if enemy_in?(diagonal_left)
    moves << diagonal_right if enemy_in?(diagonal_right)
  end
end
