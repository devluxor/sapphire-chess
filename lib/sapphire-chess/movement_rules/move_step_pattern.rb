module StepPattern
  def available_moves
    move_directions.each_with_object([]) do |(row_direction, column_direction), moves|
      current_row, current_column = location

      current_row += row_direction
      current_column += column_direction
      possible_location = [current_row, current_column]

      next unless board.within_limits?(possible_location)

      if board.empty_square?(possible_location) || enemy_in?(possible_location)
        moves << possible_location
      end
    end
  end
end
