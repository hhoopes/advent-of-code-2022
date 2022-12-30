require 'pry'
input = File.read('./short.txt')
input = input.split("\n")
length = input.length

class Node
  attr_accessor :left, :right, :value

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class List
  attr_accessor :head, :tail, :length

  def initialize()
    @head = nil
    @tail = nil
    @length = 0
  end

  def push(val)
    node = Node.new(val)
    if @head.nil?
      @head = node
      @tail = node
    else
      @tail.right = node
      node.left = @tail
      @tail = node
    end
    @length += 1
    node
  end

  def move(node, val)
    i = find_index(node)
    if val.positive?
      new_index = (val + i) % length
    else
      new_index = (i + length - val.abs - 1) % length
    end
    return if val.zero? || new_index == i

    swap(new_index, node)
  end

  def find_index_for_value(value = 0)
    i = 0
    current = head
    while current
      return i if current.value == value
      current = current.right
      i += 1
    end
  end

  def find_value_for_index(index)
    current = head
    i = 0
    while index > i
      i += 1
      current = current.right
    end
    current.value
  end

  def find_index(node) # refactor, returns an index for nil
    return 0 if head == node
    i = 0 
    current = head
    while current
      return i if current == node
      i += 1
      current = current.right
    end
  end

  def print_values
    v = []
    current = head
    loop do
      v << current.value
      break if current.right.nil?
      current = current.right
    end
    v
  end

  private

  def swap(new_index, node)
    current_node = head
    new_index.times do
      current_node = current_node.right
    end

    # check for head/tail relationships and reconnect where removed node
    original_right = node.right
    original_left = node.left
    original_left&.right = original_right if original_left
    original_right&.left = original_left if original_right
    @head = original_right if head == node
    @tail = original_left if tail == node
    
    # reconnect everything whee
    prev_right = current_node.right
    current_node&.right = node
    prev_right&.left = node
    node.left = current_node
    node.right = prev_right
  end
end

list = List.new
original_nodes = input.map { |val| list.push(val.to_i) }

original_nodes.each do |node|
  list.move(node, node.value)
end

zero_index = list.find_index_for_value(0)
sum =
list.find_value_for_index((1000 + zero_index) % list.length) +
list.find_value_for_index((2000 + zero_index) % list.length) +
list.find_value_for_index((3000 + zero_index) % list.length)

puts sum