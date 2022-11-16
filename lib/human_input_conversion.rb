module HumanInputConversion
  LETTER_RESET_VALUE = 97 # ASCII downcase 'a' numeric value: 'a'.ord
  ALGEBRAIC_NOTATION_FORMAT = /[a-h]{1}[1-8]{1}/
  CASTLING_INPUT_FORMAT = /castle [kq]{1}/

  private

  def algebraic_input
    move_input = nil
    loop do 
      move_input = gets.chomp.strip.downcase
      break if valid_input_format?(move_input)
      puts 'Please, enter a valid move_input.'
    end

    convert_algegraic_input(move_input)
  end

  def valid_input_format?(move_input)
    (move_input.size == 2 && 
      move_input.match?(ALGEBRAIC_NOTATION_FORMAT)) ||
    (move_input.size == 4 && 
      move_input[0, 2].match?(ALGEBRAIC_NOTATION_FORMAT) &&
      move_input[2, 2].match?(ALGEBRAIC_NOTATION_FORMAT)) ||
    move_input.match?(CASTLING_INPUT_FORMAT)
  end

  def convert_algegraic_input(move_input)
    case move_input.size
    when 2 then convert_single_input(move_input)
    when 4 then convert_double_input(move_input)
    else convert_castling_input(move_input)
    end
  end

  def convert_single_input(move_input)
    letter, number = move_input[0], move_input[1]
    
    row = number_to_row(number)
    column = letter_to_column(letter)

    [row, column]
  end

  def convert_double_input(move_input)
    letter, number = move_input[0], move_input[1]
    letter_end, number_end = move_input[2], move_input[3]

    row = number_to_row(number)
    column = letter_to_column(letter)

    row_end = number_to_row(number_end)
    column_end = letter_to_column(letter_end)
      
    [[row, column], [row_end, column_end]]
  end
  
  def number_to_row(number)
    (number.to_i - Board::SQUARE_ORDER).abs
  end
  
  def letter_to_column(letter)
    letter.ord - LETTER_RESET_VALUE
  end
  
  def convert_castling_input(move_input)
    side = move_input[-1] == 'k' ? :king : :queen
     [:castle, side]
  end

  def convert_to_algebraic(square)
    letter = column_to_letter(square.last)
    number = row_to_number(square.first)

    "#{letter}#{number}"
  end

  def column_to_letter(column)
    (column + LETTER_RESET_VALUE).chr
  end

  def row_to_number(row)
    (row - Board::SQUARE_ORDER).abs
  end
end