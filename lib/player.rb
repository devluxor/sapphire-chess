require_relative './board.rb'

class Player
  LETTER_RESET_VALUE = 97 # ASCII downcase 'a' numeric value: 'a'.ord
  ALGEBRAIC_NOTATION_FORMAT = /[a-h]{1}[1-8]{1}/
  
  attr_reader :color
  
  def initialize(color)
    @color = color
  end

  def get_position
    algebraic_input
  end

  private

  def algebraic_input
    position = nil
    loop do 
      puts 'Enter position in algebraic notation [letter+number, i.e.: a1]:'
      position = gets.chomp.downcase
      break if position.match?(ALGEBRAIC_NOTATION_FORMAT)
      puts 'Please, enter a valid position.'
    end
    
    letter, number = position[0], position[1]
    
    row = (number.to_i - Board::SQUARE_ORDER).abs
    column = letter.ord - LETTER_RESET_VALUE
    
    [row, column]
  end

  # def algebraic_input
  #   letter = nil
  #   loop do
  #     puts 'Enter letter: '
  #     letter = gets.chomp.downcase
  #     break if letter.match?(/[a-h]/)
  #     puts 'Enter a valid letter'
  #   end

  #   column = letter.ord - LETTER_RESET_VALUE

  #   number = nil
  #   loop do
  #     puts 'Enter number: '
  #     number = gets.chomp
  #     break if number.match?(/[1-8]/)
  #     puts 'Enter a valid number'
  #   end

  #   row = (number.to_i - 8).abs

  #   [row, column]
  # end
end