require 'pry'

class Forest
  attr_accessor :rows, :cols, :x_length, :y_length

  def initialize(input)
    @rows = input.split("\n").map{ |s| s.chars.map(&:to_i) }
    @cols = rows.transpose
    @x_length = cols.size
    @y_length = rows.size
    @visible = x_length * y_length
  end

  def detect_visible
    rows.map.with_index do |row, y|
      next if y == 0 || y == y_length - 1 
      row.map.with_index do |char, x|
        next if x == 0 || x == x_length - 1 
        if (row[0..x].max != char || row[0..x - 1].include?(char) ) && (row[x..-1].max != char || row[x + 1..-1].include?(char) ) && (cols[x][0..y].max != char || cols[x][0..y-1].include?(char)) && (cols[x][y..-1].max != char || cols[x][y + 1..-1].include?(char))
          @visible -= 1
        end
      end
    end
    @visible
  end
end

input = File.read('./input.txt')
puts Forest.new(input).detect_visible