class Course
  attr_reader :teachers, :topics
  attr_accessor :title

  def initialize(title)
    @title = title
    @teachers = []
    @topics = []
  end

  def add_teacher(teacher)
    @teachers << teacher
  end

  def add_topic(topic)
    @topics << topic
  end

  def to_s
    teachers_str = @teachers.map(&:to_s).join(', ')
    topics_str = @topics.map(&:to_s).join(', ')
    "Course: #{@title}\nTeachers: #{teachers_str}\nTopics: #{topics_str}"
  end
end 
