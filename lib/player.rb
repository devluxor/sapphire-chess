class Player
  attr_reader :color
  
  def initialize(color)
    @color = color
  end

  def get_position
    raw_position = gets.chomp
    raw_position.split(',').map(&:to_i)
  end
end