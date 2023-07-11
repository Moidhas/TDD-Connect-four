# frozen_string_literal: true

# Player
class Player
  def input_position
    loop do
      col = input_troubles
      break col if col.between?(0, 6)
    end
  end

  def input_troubles
    print 'Please pick a column in between 0 and 6: '
    value = gets.chomp
    Integer(value)
  rescue ArgumentError
    puts "#{value}, is not a valid integer"
    -1
  end
end
