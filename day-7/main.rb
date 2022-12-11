class Directory
  attr_accessor :data, :name, :children, :parent

  def initialize(name, data: 0, children: {}, parent: nil)
    @name = name
    @data = data
    @children = children
    @parent = parent
  end

  def key_prefix
    node = parent
    prefix = name
    until node.nil?
      prefix += '_' + node.name
      node = node.parent
    end
    prefix
  end
end

@sizes = {}

def calculate_dir_size(input)
  tree = build_tree(input)
  @root_size = tree.data + add_sizes(tree.children)
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
  current_dir = Directory.new('/')
  root = current_dir

  input.split("\n").each do |line|
    case line
    when '$ cd /'
    when '$ cd ..'
      current_dir = current_dir.parent
    when /\$ cd (.+)/
      key = current_dir.key_prefix + $1
      current_dir = current_dir.children[key]
    when '$ ls' 
    when /(\d+) .+/
      current_dir.data += $1.to_i
    when /dir (.+)/
      key = current_dir.key_prefix + $1
      current_dir.children[key] = Directory.new(key, parent: current_dir)
    end
  end
  root
end

input = File.read('./input.txt')

output = calculate_dir_size(input)
puts output.values.select { |v| v <= 100000 }.sum

# part 2
remainder =  @root_size - 40000000
result =  output.sort_by { |k, v| v }.detect{ |v| v.last >= remainder }