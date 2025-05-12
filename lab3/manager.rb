require 'json'
require 'yaml'
require_relative 'course'
require_relative 'teacher'
require_relative 'topic'

class Manager
  def initialize
    @courses = []
  end

  def find_course(title)
    @courses.find { |course| course.title.downcase == title.downcase }
  end

  def add_course(course)
    @courses << course
  end

  def delete_course(title)
    @courses.delete_if { |course| course.title.downcase == title.downcase }
  end

  def edit_course(title, new_title = nil, new_teachers = nil, new_topics = nil)
    course = find_course(title)
    return false unless course

    course.title = new_title if new_title
    
    if new_teachers
      course.teachers.clear
      new_teachers.each { |teacher_name| course.add_teacher(Teacher.new(teacher_name)) }
    end
    
    if new_topics
      course.topics.clear
      new_topics.each { |topic_name| course.add_topic(Topic.new(topic_name)) }
    end
    
    true
  end

  def search_courses(query)
    @courses.select do |course|
      course.title.downcase.include?(query.downcase) ||
        course.teachers.any? { |teacher| teacher.to_s.downcase.include?(query.downcase) } ||
        course.topics.any? { |topic| topic.to_s.downcase.include?(query.downcase) }
    end
  end

  def list_courses
    if @courses.empty?
      puts "No courses in the catalog."
    else
      puts "\n===== COURSE CATALOG =====\n"
      @courses.each do |course|
        puts course.to_s
        puts "-----------------------"
      end
    end
  end

  def save_to_json(filename)
    data = {}
    @courses.each do |course|
      data[course.title] = {
        "teachers" => course.teachers.map(&:to_s),
        "topics" => course.topics.map(&:to_s)
      }
    end
    
    File.write("#{filename}.json", JSON.pretty_generate(data))
  end

  def save_to_yaml(filename)
    data = {}
    @courses.each do |course|
      data[course.title] = {
        "teachers" => course.teachers.map(&:to_s),
        "topics" => course.topics.map(&:to_s)
      }
    end
    
    File.write("#{filename}.yml", data.to_yaml)
  end

  def load_from_json(filename)
    begin
      full_path = "#{filename}.json"
      puts "Attempting to load from: #{full_path}"
      
      if !File.exist?(full_path)
        puts "File not found: #{full_path}"
        return false
      end
      
      file_content = File.read(full_path)
      
      data = JSON.parse(file_content)
      puts "Parsed JSON data successfully"
      
      @courses = []
    
      data.each do |title, details|
        course = Course.new(title.to_s)
        
        if details.is_a?(Hash)
          if details["teachers"] || details[:teachers]
            teachers = details["teachers"] || details[:teachers] || []
            teachers.each do |teacher_name|
              course.add_teacher(Teacher.new(teacher_name))
            end
          end
          
          if details["topics"] || details[:topics]
            topics = details["topics"] || details[:topics] || []
            topics.each do |topic_name|
              course.add_topic(Topic.new(topic_name))
            end
          end
        end
        
        @courses << course
      end
      
      puts "Loaded #{@courses.size} courses successfully"
      true
    rescue => e
      puts "Error loading JSON: #{e.message}"
      puts e.backtrace.join("\n")
      false
    end
  end

  def load_from_yaml(filename)
    begin
      full_path = "#{filename}.yml"
      puts "Attempting to load from: #{full_path}"
      
      if !File.exist?(full_path)
        puts "File not found: #{full_path}"
        return false
      end
      
      data = YAML.load_file(full_path)
      puts "Parsed YAML data successfully"
      
      @courses = []
      
      data.each do |title, details|
      course = Course.new(title.to_s)
      
      if details["teachers"] || details[:teachers]
        teachers = details["teachers"] || details[:teachers] || []
        teachers.each do |teacher_name|
          course.add_teacher(Teacher.new(teacher_name))
        end
      end
      
      if details["topics"] || details[:topics]
        topics = details["topics"] || details[:topics] || []
        topics.each do |topic_name|
          course.add_topic(Topic.new(topic_name))
        end
      end
        
        @courses << course
      end
      
      puts "Loaded #{@courses.size} courses successfully"
      true
    rescue => e
      puts "Error loading YAML: #{e.message}"
      puts e.backtrace.join("\n")
      false
    end
  end
end 