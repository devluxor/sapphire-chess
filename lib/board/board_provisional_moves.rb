module ProvisionalMoves
  def make_provisional!(move)
    if move.first == :castle
      side = move.last
      castle!(side, color)
    else
      start_position, target_position = move
      piece_buffer = self[target_position]
      move_piece!(start_position, target_position)
    end
  end

  def unmake_provisional!(piece_buffer, move)
    if move.first == :castle
      side = move.last
      uncastle!(side, color)
    else
      start_position, target_position = move
      move_piece!(target_position, start_position)
      self[target_position] = piece_buffer
    end
  end
end