class Topic
  attr_reader :name

  def initialize(name)
    @name = name.strip
  end

  def to_s
    @name
  end
end 