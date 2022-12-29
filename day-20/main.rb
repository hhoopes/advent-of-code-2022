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
    node.left.right = node.right if node.left
    node.right.left = node.left if node.right
    node
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
# binding.pry
    # check for head/tail relationships and reconnect where removed node
    original_right = node.right
    original_left = node.left
    original_left&.right = original_right if original_left
    original_right&.left = original_left if original_right
    @head = original_right if head == node
    @tail = original_left if tail == node
    
    # reconnect everything whee
    binding.pry
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
    mode = val.positive? ? :right : :left 

    will_lap, new_index = (val + i).divmod length
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
      new_index -= 1 if will_lap > 0
      swap(new_index, node)
    end
  end
end

list = List.new
original_nodes = input.map { |val| list.push(val.to_i) }

original_nodes.each do |node|
  list.move(node, node.value)
end
binding.pry
# some bug where a value isn't being accounted for properly, and values doesn't return. 
# 3 is still listed as the right node of 2, but 2 is correctly established as the tail. Probably when move 3, need to reassign left/right for its prev neighbors
# thought I fixed, but now the 3 & 2 are switched, while the tail shows properly as the 2
puts list.values