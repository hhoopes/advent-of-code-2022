require 'pry'
POINT_MAPPING = {
  A: 1,
  X: 1,
  B: 2,
  Y: 2,
  C: 3,
  Z: 3
}

ROUND_SCORING = {
  AX: 3,
  AY: 6,
  AZ: 0,
  BX: 0,
  BY: 3,
  BZ: 6,
  CX: 6,
  CY: 0,
  CZ: 3
}

PART_TWO_MAPPING = {
  X: 0,
  Y: 3,
  Z: 6
}

def part_1(input)
  input.split("\n").inject(0) do | sum, round | 
    you = round.split(' ').last
    sum += POINT_MAPPING[you.to_sym] + ROUND_SCORING[round.sub(' ', '').to_sym]
  end
end

def part_2(input)
  input.split("\n").inject(0) do | sum, round | 
    you = round.split(' ').last
    desired_score = PART_TWO_MAPPING[you.to_sym]
    your_move = ROUND_SCORING.detect do |combo, score|
      opponent = combo.to_s.split('').first
      score == desired_score && opponent == round.split(' ').first
    end.first.to_s.split('').last
  
    sum += desired_score + POINT_MAPPING[your_move.to_sym]
  end
end

input = File.read('./input.txt')
puts part_2(input)