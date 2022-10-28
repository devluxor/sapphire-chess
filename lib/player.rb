class Player
  LETTER_RESET_VALUE = 97 # ASCII downcase 'a' numeric value: 'a'.ord
  
  attr_reader :color
  
  def initialize(color)
    @color = color
  end

  def get_position
    algebraic_input
  end

  def algebraic_input
    letter = nil
    loop do
      puts 'Enter letter: '
      letter = gets.chomp.downcase
      break if letter.match?(/[a-h]/)
      puts 'Enter a valid letter'
    end

    column = letter.ord - A_RESET_VALUE

    number = nil
    loop do
      puts 'Enter number: '
      number = gets.chomp
      break if number.match?(/[1-8]/)
      puts 'Enter a valid number'
    end

    row = (number.to_i - 8).abs

    [row, column]
  end
end