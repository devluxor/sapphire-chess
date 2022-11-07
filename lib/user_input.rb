module UserInput
  LETTER_RESET_VALUE = 97 # ASCII downcase 'a' numeric value: 'a'.ord
  ALGEBRAIC_NOTATION_FORMAT = /[a-h]{1}[1-8]{1}/
  CASTLING_INPUT_FORMAT = /castle [kq]{1}/

  private

  # See Engine#turn! and Engine#convert_player_input
  def algebraic_input
    position = nil
    loop do 
      position = gets.chomp.strip.downcase
      break if valid_input_format?(position)
      puts 'Please, enter a valid position.'
    end

    convert_algegraic_input(position)
  end

  def valid_input_format?(position)
    (position.size == 2 && 
      position.match?(ALGEBRAIC_NOTATION_FORMAT)) ||
    (position.size == 4 && 
      position[0, 2].match?(ALGEBRAIC_NOTATION_FORMAT) &&
      position[2, 2].match?(ALGEBRAIC_NOTATION_FORMAT)) ||
    position.match?(CASTLING_INPUT_FORMAT)
  end

  def convert_algegraic_input(position)
    case position.size
    when 2 then convert_single_input(position)
    when 4 then convert_double_input(position)
    else convert_castling_input(position)
    end
  end

  def convert_single_input(position)
    letter, number = position[0], position[1]
    
    row = number_to_row(number)
    column = letter_to_column(letter)

    [row, column]
  end

  def convert_double_input(position)
    letter, number = position[0], position[1]
    letter_end, number_end = position[2], position[3]

    row = number_to_row(number)
    column = letter_to_column(letter)

    row_end = number_to_row(number_end)
    column_end = letter_to_column(letter_end)
      
    [[row, column], [row_end, column_end]]
  end

  def convert_castling_input(position)
    side = position[-1] == 'k' ? :king : :queen

    [:castle, side]
  end

  def number_to_row(number)
    (number.to_i - Board::SQUARE_ORDER).abs
  end

  def letter_to_column(letter)
    letter.ord - LETTER_RESET_VALUE
  end
end