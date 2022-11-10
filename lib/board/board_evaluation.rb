module BoardEvaluation
  # I could add a difficulty selection: 
        # if easy, only depth 1 and only material evaluation
        # if medium, depth 3, only material evaluation
        # if hard, depth 3, material and piece location evaluation
  def evaluate
    material_evaluation + piece_location_evaluation
    # material_evaluation
    # piece_location_evaluation
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
end