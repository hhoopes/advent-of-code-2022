def find_start(input, distinct_chars: 4)
  chars = input.chars
  chars.each_with_index do |c, i|
    finish = i + distinct_chars - 1 
    return finish + 1 if chars[i..finish].uniq.count == distinct_chars 
  end
end

input = File.read('./input.txt')
puts find_start(input, distinct_chars: 14)