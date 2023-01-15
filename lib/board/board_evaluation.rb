module BoardEvaluation
  def evaluate
    material_evaluation + piece_location_evaluation
  end

  def material_evaluation
    white_evaluation = friendly_pieces(:white).map(&:value).sum
    black_evaluation = -friendly_pieces(:black).map(&:value).sum

    white_evaluation + black_evaluation
  end

  def piece_location_evaluation
    white_evaluation = friendly_pieces(:white).map(&:location_value).sum
    black_evaluation = -friendly_pieces(:black).map(&:location_value).sum

    white_evaluation + black_evaluation
  end

  def evaluate_move(move, color)
    provisional(move, color) do
      evaluate
    end
  end
end
