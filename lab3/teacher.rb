class Teacher
  attr_reader :name

  def initialize(name)
    @name = name.strip
  end

  def to_s
    @name
  end
end 