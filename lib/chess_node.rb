
class Chess_Node
  attr_reader :move, :parent, :base_value, :children, :avg_value
  def initialize(move, parent, value)
    @move = move
    @parent = parent
    @base_value = value
    @avg_value = 0
    @children = []
  end

  def update_avg
    total = @base_value
    total_children = 1
    @children.each do |child|
      child.update_avg
      total += child.avg_value
      total_children += 1
    end
    @avg_value = total / total_children
  end

  def append_child(child)
    @children.push(child)
  end

  def to_s
    return "#{@move}, #{@base_value}"
  end
end