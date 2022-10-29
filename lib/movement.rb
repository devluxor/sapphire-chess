module Stepable
  # Maybe shorten/refactor
  def available_moves
    move_directions.each_with_object([]) do |(row_direction, column_direction), moves|
      current_row, current_column = location

      current_row += row_direction
      current_column += column_direction
      possible_location = [current_row, current_column]

      next if !board.in_bounds?(possible_location)

      if board.empty_square?(possible_location) || enemy_in?(possible_location)
        moves << possible_location
      end
    end
  end
end

module Slideable
  # Maybe shorten/refactor
  def available_moves
    move_directions.each_with_object([]) do |(row_direction, column_direction), moves|
      current_row, current_column = location

      loop do
        current_row += row_direction
        current_column += column_direction
        possible_location = [current_row, current_column]

        break if !board.in_bounds?(possible_location)
        break if friend_in?(possible_location)

        moves << possible_location if board.empty_square?(possible_location)

        if enemy_in?(possible_location)
          moves << possible_location
          break
        end
      end
    end
  end
end