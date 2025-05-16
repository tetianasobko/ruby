require 'json'
require 'yaml'

def add_course(collection, title, teachers, topics)
  collection[title.to_sym] = { teachers: teachers, topics: topics }
end

def edit_course(collection, title, new_teachers = nil, new_topics = nil)
  return unless collection.key?(title.to_sym)

  collection[title.to_sym][:teachers] = new_teachers unless new_teachers.nil?
  collection[title.to_sym][:topics] = new_topics unless new_topics.nil?
end

def delete_course(collection, title)
  collection.delete(title.to_sym)
end

def search_courses(collection, keyword)
  collection.select do |title, details|
    title.to_s.downcase.include?(keyword.downcase) ||
      details[:teachers].any? { |t| t.downcase.include?(keyword.downcase) } ||
      details[:topics].any? { |t| t.downcase.include?(keyword.downcase) }
  end
end

def output_courses(collection)
  collection.each do |title, details|
    puts "\nCourse: #{title}"
    puts "Teachers: #{details[:teachers].join(', ')}"
    puts "Topics: #{details[:topics].join(', ')}"
  end
end

def save_to_json(collection, filename)
    File.write(filename, JSON.pretty_generate(collection))
end

def load_from_json(filename)
  JSON.parse(File.read(filename), symbolize_names: true) rescue {}
end

def save_to_yaml(collection, filename)
  data = {}
  collection.each do |title, details|
    data[title.to_s] = {
      "teachers" => details[:teachers].map(&:to_s),
      "topics" => details[:topics].map(&:to_s)
    }
  end
  File.write(filename, data.to_yaml)
end

def load_from_yaml(filename)
  YAML.load_file(filename, symbolize_names: true) rescue {}
end

def main
  courses = load_from_yaml("courses.yml") rescue {}

  # add_course(courses, "Mathematical Modeling", ["Yaroslav Bihun", "Oleh Ukrainets"], ["Population Growth", "Spread of infectious diseases"])
  # add_course(courses, "Python Fundamentals", ["Ihor Skutar"], ["Syntax", "Data Structures"])
  
  edit_course(courses, "Mathematical Modeling", ["Yaroslav Bihun"], ["Population Growth", "Spread of infectious diseases"])
  
  delete_course(courses, "Python Fundamentals")
  
  add_course(courses, "Ruby on Rails", ["Nataliia Romanenko"], ["Data Types", "Classes", "Validation"])

  puts "\nSearch results for 'ruby':"
  search_results = search_courses(courses, "ruby")
  output_courses(search_results)

  puts "\nAll courses:"
  output_courses(courses)

  save_to_json(courses, "courses.json")
  save_to_yaml(courses, "courses.yml")
  
  puts "\nData saved to courses.json and courses.yml"
end

main if __FILE__ == $0 