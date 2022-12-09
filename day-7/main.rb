class Directory
  attr_accessor :data, :name, :children, :parent

  def initialize(name, data: 0, children: {}, parent: nil)
    @name = name
    @data = data
    @children = children
    @parent = parent
  end
end

@sizes = {}

def calculate_dir_size(input)
  tree = build_tree(input)
  add_sizes(tree.children)
  @sizes
end

def add_sizes(children)
  children.map do |k, v|
    size = v.data + add_sizes(v.children)
    @sizes[k] = size
    size
  end.sum
end

def build_tree(input, key: '/')
  pwd = Directory.new('/')
  root = pwd

  input.split("\n").each do |line|
    case line
    when /\$ cd \//
    when /\$ cd \.\./
      pwd = pwd.parent
    when /\$ cd (.+)/
      key = $1
      pwd = pwd.children[key]
    when '$ ls' 
    when /(\d+) .+/
      pwd.data += $1.to_i
    when /dir (.+)/
      key = $1
      pwd.children[key] = Directory.new(key, parent: pwd) 
    end
  end
  root
end

input = File.read('./input.txt')

puts output = calculate_dir_size(input)
puts output.values.select { |v| v <= 100000 }.sum
