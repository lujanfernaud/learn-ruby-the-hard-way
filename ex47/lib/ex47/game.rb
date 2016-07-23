class Room
  
  def initialize(name, description)
    @name = name
    @description = description
    @paths = {}
  end

  attr_reader :name, :description, :paths

  def go(direction)
    return @paths[direction]
  end

  def add_paths(paths)
    @paths.update(paths)
  end
end