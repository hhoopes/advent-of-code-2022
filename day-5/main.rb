rows, instructions = File.read('./input.txt').split("\n\n")

crates = rows.split("\n")
             .tap {|r| r.pop}  # don't need last row where we're going
             .map{|chars| chars << ' '; chars.scan(/.{4}/)} # chunk it up by groups of 4
             .transpose # create new arrays aligned by index
             .map{|r| r.join('') # clean it up
                      .lstrip
                      .split(' ')
                 }
                
# for part 1, can either reverse to_move, or can use quantity as an iterator
instructions.split("\n").each do |i|
  quantity, origin, destination  = i.match(/(\d+).+(\d+).+(\d+)/).captures.map(&:to_i)
  to_move = crates[origin - 1].slice!(0, quantity)
  crates[destination - 1].unshift(*to_move)
end

puts crates.map(&:first).join.gsub(/\W/, '')