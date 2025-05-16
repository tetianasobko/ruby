require 'json'
require 'yaml'

$courses = {}

def add_course
  print 'Course name: '
  title = gets.chomp.to_sym

  print 'Teachers: '
  teachers = gets.chomp.split(',').map(&:strip)

  print 'Topics: '
  topics = gets.chomp.split(',').map(&:strip)

  $courses[title] = { teachers: teachers, topics: topics }
  puts "Course '#{title}' added successfully!"
end

def edit_course
  print 'Enter course name: '
  name = gets.chomp
  
  key = $courses.keys.find { |k| k.to_s.downcase == name.downcase }
  
  return puts 'Course not found' unless key

  print 'Enter new name (or leave empty to not change): '
  new_title = gets.chomp
  
  unless new_title.empty?
    $courses[new_title] = $courses.delete(key)
    key = new_title
  end

  details = $courses[key]
  
  print 'Enter new teachers (comma-separated, or leave empty to not change): '
  new_teachers = gets.chomp
  
  unless new_teachers.empty?
    teacher_array = new_teachers.split(',').map(&:strip)
    # Update using the key format in the current details
    if details.key?(:teachers)
      details[:teachers] = teacher_array
    else
      details["teachers"] = teacher_array
    end
  end

  print 'Enter new topics (comma-separated, or leave empty to not change): '
  new_topics = gets.chomp
  
  unless new_topics.empty?
    topic_array = new_topics.split(',').map(&:strip)
    # Update using the key format in the current details
    if details.key?(:topics)
      details[:topics] = topic_array
    else
      details["topics"] = topic_array
    end
  end
  
  puts "Course '#{key}' updated successfully!"
end

def delete_course
  print 'Enter course name to delete: '
  name = gets.chomp.to_sym
  if $courses.delete(name)
    puts "Course '#{name}' deleted successfully!"
  else
    puts 'Course not found'
  end
end

def search_course
  print 'What are we searching for: '
  query = gets.chomp.downcase

  results = $courses.select do |title, details|
    teachers = details[:teachers] || details["teachers"] || []
    topics = details[:topics] || details["topics"] || []
    
    title.to_s.downcase.include?(query) ||
      teachers.any? { |teacher| teacher.to_s.downcase.include?(query) } ||
      topics.any? { |topic| topic.to_s.downcase.include?(query) }
  end

  if results.empty?
    puts "No courses found matching '#{query}'."
  else
    puts "Found #{results.size} courses:"
    results.each do |title, details|
      puts "Course: #{title}"
      teachers = details[:teachers] || details["teachers"] || []
      topics = details[:topics] || details["topics"] || []
      puts "Teachers: #{teachers.join(', ')}"
      puts "Topics: #{topics.join(', ')}"
      puts "-----------------------"
    end
  end
end

def load_from_file
  puts "1. Load from JSON"
  puts "2. Load from YAML"
  print "Select format: "
  
  format = gets.to_i
  
  print 'Enter filename (without extension): '
  filename = gets.chomp
  
  case format
  when 1
    begin
      $courses = JSON.parse(File.read("#{filename}.json"))
      puts "Data loaded from #{filename}.json successfully!"
    rescue
      puts "Error loading from JSON file. Check if the file exists and contains valid JSON."
    end
  when 2
    begin
      $courses = YAML.load_file("#{filename}.yml")
      puts "Data loaded from #{filename}.yml successfully!"
    rescue
      puts "Error loading from YAML file. Check if the file exists and contains valid YAML."
    end
  else
    puts "Invalid format selected."
  end
end

def save_to_file(format)
  print 'Name of file to save (without extension): '
  filename = gets.chomp

  case format
  when :json
    File.write("#{filename}.json", JSON.pretty_generate($courses))
    puts "Data saved to #{filename}.json successfully!"
  when :yaml
    data = {}
    $courses.each do |title, details|
      teachers = details["teachers"] || []
      topics = details[:topics] || details["topics"] || []
      
      data[title.to_s] = {
        "teachers" => teachers.map(&:to_s),
        "topics" => topics.map(&:to_s)
      }
    end
    File.write("#{filename}.yml", data.to_yaml)
    puts "Data saved to #{filename}.yml successfully!"
  end
end

def show_courses
  if $courses.empty?
    puts "No courses in the catalog."
    return
  end
  
  puts "\nCOURSE CATALOG:"
  puts "================="
  
  $courses.each do |title, details|
    puts "\nCourse: #{title}"
    # Handle both symbol and string keys
    teachers = details[:teachers] || details["teachers"] || []
    topics = details[:topics] || details["topics"] || []
    puts "Teachers: #{teachers.join(', ')}"
    puts "Topics: #{topics.join(', ')}"
    puts "-----------------------"
  end
end

# Main menu
puts "Welcome to Course Management System"

loop do
  puts "\n===== MENU ====="
  puts "1. Add course"
  puts "2. Edit course"
  puts "3. Delete course"
  puts "4. Search course"
  puts "5. Load from file"
  puts "6. Save to JSON"
  puts "7. Save to YAML"
  puts "8. Show all courses"
  puts "9. Exit"
  print "Choose an option: "

  case gets.to_i
  when 1 then add_course
  when 2 then edit_course
  when 3 then delete_course
  when 4 then search_course
  when 5 then load_from_file
  when 6 then save_to_file(:json)
  when 7 then save_to_file(:yaml)
  when 8 then show_courses
  when 9
    puts "Thank you for using Course Management System. Goodbye!"
    break
  else puts "Incorrect choice. Please try again."
  end
end 