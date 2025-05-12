require_relative 'course'
require_relative 'teacher'
require_relative 'topic'

class UserInterface
  def initialize(manager)
    @manager = manager
  end

  def prompt(message)
    print message
    gets.chomp
  end

  def add_course
    title = prompt("Enter course title: ")
    course = Course.new(title)

    teachers_input = prompt("Enter teachers (comma-separated): ")
    teachers_input.split(',').each do |t|
      course.add_teacher(Teacher.new(t))
    end

    topics_input = prompt("Enter topics (comma-separated): ")
    topics_input.split(',').each do |t|
      course.add_topic(Topic.new(t))
    end

    @manager.add_course(course)
    puts "Course added!"
  end

  def delete_course
    title = prompt("Enter title of course to delete: ")
    @manager.delete_course(title)
    puts "Course deleted if it existed."
  end

  def edit_course
    title = prompt("Enter title of course to edit: ")
    course = @manager.find_course(title)
    
    unless course
      puts "Course not found."
      return
    end
    
    puts "\nEditing course: #{course.title}"
    puts "1. Edit title"
    puts "2. Edit teachers"
    puts "3. Edit topics"
    puts "4. Cancel"
    
    choice = prompt("Choose what to edit: ").to_i
    
    case choice
    when 1
      new_title = prompt("Enter new title: ")
      if @manager.edit_course(title, new_title)
        puts "Title updated successfully."
      end
    when 2
      teachers_input = prompt("Enter new teachers (comma-separated): ")
      new_teachers = teachers_input.split(',').map(&:strip)
      if @manager.edit_course(title, nil, new_teachers)
        puts "Teachers updated successfully."
      end
    when 3
      topics_input = prompt("Enter new topics (comma-separated): ")
      new_topics = topics_input.split(',').map(&:strip)
      if @manager.edit_course(title, nil, nil, new_topics)
        puts "Topics updated successfully."
      end
    when 4
      puts "Edit cancelled."
    else
      puts "Invalid choice."
    end
  end

  def search_courses
    query = prompt("Enter search query: ")
    results = @manager.search_courses(query)
    
    if results.empty?
      puts "No courses found matching '#{query}'."
    else
      puts "\nFound #{results.size} courses:"
      results.each do |course| 
        puts course.to_s
        puts "-----------------------"
      end
    end
  end

  def save_data
    puts "1. Save to JSON"
    puts "2. Save to YAML"
    choice = prompt("Select format: ").to_i
    
    filename = prompt("Enter filename (without extension): ")
    
    case choice
    when 1
      @manager.save_to_json(filename)
      puts "Data saved to #{filename}.json"
    when 2
      @manager.save_to_yaml(filename)
      puts "Data saved to #{filename}.yml"
    else
      puts "Invalid choice."
    end
  end

  def load_data
    puts "1. Load from JSON"
    puts "2. Load from YAML"
    choice = prompt("Select format: ").to_i
    
    filename = prompt("Enter filename (without extension): ")
    
    success = case choice
              when 1
                @manager.load_from_json(filename)
              when 2
                @manager.load_from_yaml(filename)
              else
                puts "Invalid choice."
                false
              end
    
    if success
      puts "Data loaded successfully."
    else
      puts "Error loading data. Check if the file exists and contains valid data."
    end
  end

  def run
    puts "Welcome to Course Management System"
    
    loop do
      puts "\n===== MENU ====="
      puts "1. Add course"
      puts "2. Delete course"
      puts "3. Edit course"
      puts "4. Search courses"
      puts "5. List all courses"
      puts "6. Save data"
      puts "7. Load data"
      puts "8. Exit"
      choice = prompt("Choose an option: ").to_i

      case choice
      when 1 then add_course
      when 2 then delete_course
      when 3 then edit_course
      when 4 then search_courses
      when 5 then @manager.list_courses
      when 6 then save_data
      when 7 then load_data
      when 8
        puts "Thank you for using Course Management System. Goodbye!"
        break
      else 
        puts "Invalid choice."
      end
    end
  end
end 