require 'singleton'

class EmptySquare
  include Singleton

  def to_s
    '  '
  end

  def white
    '██'
  end
end
