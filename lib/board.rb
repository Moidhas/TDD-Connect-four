# frozen_string_literal: true
# rubocop: disable Metrics/ClassLength
# rubocop: disable Metrics/MethodLength

require_relative 'player'

# Board
class Board
  YELLOW = "\e[33m\u25cf\e[0m"
  BLUE = "\e[34m\u25cf\e[0m"
  EMPTY = "\u25cb"

  def initialize(p1 = Player.new(0), p2 = player.new(1), state = Array.new(7) { Array.new(6) })
    @p1 = p1
    @p2 = p2
    @state = state
  end

  def play_game
    loop do
      update_board(@p1)
      pretty_print
      break input_message(@p1) if game_over?(@p1)

      update_board(@p2)
      pretty_print
      break input_message(@p2) if game_over?(@p2)
    end
  end

  def update_board(player)
    loop do
      p_col = player.input_position
      p_row = @state[p_col].index(&:nil?)
      break @state[p_col][p_row] = player.id if p_row
    end
  end

  def game_over?(player)
    col_over?(player) || row_over?(player) || right_diag_over?(player) || left_diag_over?(player)
  end

  private

  def left_diag_over?(player)
    id = player.id
    col = 6
    while col >= 3
      diag_entries = []
      x = col
      row = 0
      while x >= 0 && row <= 5
        diag_entries << @state[x][row]
        x -= 1
        row += 1
      end
      bound = diag_entries.length - 4
      0.upto(bound) { |i| return true if diag_entries[i..(i + 3)].all?(id) }
      col -= 1
    end

    row = 1
    while row <= 2
      diag_entries = []
      col = 6
      y = row
      while col >= 0 && y <= 5
        diag_entries << @state[col][y]
        y += 1
        col -= 1
      end

      bound = diag_entries.length - 4
      0.upto(bound) { |i| return true if diag_entries[i..(i + 3)].all?(id) }
      row += 1
    end
    false
  end

  def right_diag_over?(player)
    id = player.id
    col = 0
    while col <= 3 
      diag_entries = []
      x = col
      row = 0
      while x <= 6 && row <= 5
        diag_entries << @state[x][row]
        x += 1
        row += 1
      end

      bound = diag_entries.length - 4
      0.upto(bound) { |i| return true if diag_entries[i..(i + 3)].all?(id) }
      col += 1
    end

    row = 1

    while row <= 2
      diag_entries = []
      col = 0
      y = row
      while col <= 6 && y <= 5
        diag_entries << @state[col][y]
        y += 1
        col += 1
      end

      bound = diag_entries.length - 4
      0.upto(bound) { |i| return true if diag_entries[i..(i + 3)].all?(id) }
      row += 1
    end
    false
  end

  def row_over?(player)
    id = player.id
    @state.transpose.each do |row|
      0.upto(2) { |i| return true if row[i..(i + 3)].all?(id) }
    end
    false
  end

  def col_over?(player)
    id = player.id
    @state.each do |col|
      0.upto(3) { |i| return true if col[i..(i + 3)].all?(id) }
    end
    false
  end

  def pretty_print
    pretty_board = @state.transpose.reverse
    pretty_board.each do |row|
      row.each do |piece|
        print "#{EMPTY} " if piece.nil?
        print "#{BLUE} " if piece == 0
        print "#{YELLOW} " if piece == 1
      end
      puts
    end
  end

  def input_message(player)
    puts '!' * 25
    color = player.id.zero? ? 'blue' : 'yellow'
    puts "CONGRATS Player #{color} you won"
    puts '!' * 25
  end
end

Board.new(Player.new(0), Player.new(1)).play_game
