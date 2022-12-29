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

  def remove(node)
    @head = node.right if @head == node
    @tail = node.left if @tail == node
    node.left.right = node.right if node.left
    node.right.left = node.left if node.right
    node
  end

  def find_index_for_value(value = 0)
    i = 0
    current = head
    while current
      return i if current.value == value
      current = current.right
      i += 1
    end
    i
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

  def values
    v = []
    current = head
    loop do 
      v << current.value 
      break if current.right.nil?
      current = current.right 
    end
    v
  end

  def move(node, val)
    i = find_index(node)
    if val.positive?
      will_lap, new_index = (val + i).divmod length
    else
      will_lap, new_index = (i + length - val.abs - 1).divmod length
    end
    return if val.zero? || new_index == i

    new_head = true if new_index.zero?
    new_tail = true if new_index == length - 1

    if new_head
      current_node = remove(node)
      old_head = @head
      @head = current_node
      old_head.left = current_node
      current_node.right = old_head 
      current_node.left = nil
    elsif new_tail
      current_node = remove(node)
      old_tail = @tail
      @tail = current_node
      old_tail.right = current_node
      current_node.left = old_tail
      current_node.right = nil
    else
      # new_index -= 1 if will_lap > 0
      swap(new_index, node)
    end
  end
end

list = List.new
original_nodes = input.map { |val| list.push(val.to_i) }

original_nodes.each do |node|
  list.move(node, node.value)
end
# puts list.values

zero_index = list.find_index_for_value(0)
sum = 
list.find_value_for_index(1000 + zero_index % list.length) +
list.find_value_for_index(2000 + zero_index % list.length) +
list.find_value_for_index(3000 + zero_index % list.length)

puts sum