require 'pry'

class Forest
  attr_accessor :rows, :cols, :x_length, :y_length, :scenic_scores

  def initialize(input)
    @rows = input.split("\n").map { |s| s.chars.map(&:to_i) }
    @cols = rows.transpose
    @x_length = cols.size
    @y_length = rows.size
    @visible = x_length * y_length
  end

  def detect_visible
    @scenic_scores = rows.map.with_index do |row, y|
      next if y.zero? || y == y_length - 1 # edge

      row.map.with_index do |tree, x|
        next if x.zero? || x == x_length - 1 # edge

        if (row[0..x].max != tree || row[0..x - 1].include?(tree)) && (row[x..].max != tree || row[x + 1..].include?(tree)) && (cols[x][0..y].max != tree || cols[x][0..y - 1].include?(tree)) && (cols[x][y..].max != tree || cols[x][y + 1..].include?(tree))
          @visible -= 1
        end

        left = scenic_score(row[0..x - 1].reverse, tree)
        right = scenic_score(row[x + 1..], tree)
        up = scenic_score(cols[x][0..y - 1].reverse, tree)
        down = scenic_score(cols[x][y + 1..], tree)
        left * right * up * down
      end
    end
    @visible
  end

  def scenic_score(sequence, point_of_reference)
    return 1 if sequence.size == 1

    prev = 0
    score = 0
    sequence.each do |tree|
      return score if prev > tree

      score += 1
      return score if tree >= point_of_reference

      prev = tree
    end
    score
  end

  def max_scenic_score
    @scenic_scores.flatten.compact.max
  end
end

input = File.read('./input.txt')
f = Forest.new(input)
puts "Visible: #{f.detect_visible}"
puts f.max_scenic_score
