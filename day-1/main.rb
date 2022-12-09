def find_max_cal(input, top_counts: 1)
  input.map do |elf|
    elf.split("\n").sum(&:to_i)
  end.max(top_counts)
end

individual_elves = File.read('./input.txt')
                          .split("\n\n")

puts find_max_cal(individual_elves)
puts find_max_cal(individual_elves, top_counts: 3).sum