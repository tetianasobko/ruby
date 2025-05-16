# test.rb - Script to test model validations
# Run with: rails runner test.rb

# Clear the console
puts "\n" * 50

puts "===== TESTING MODEL VALIDATIONS ====="

# Test Course validations
puts "\n=== COURSE VALIDATIONS ==="

# Valid course
puts "\nTrying to create a valid course:"
course = Course.new(title: "Ruby Programming")
if course.valid?
  course.save
  puts "✅ Success: Course created with id: #{course.id}"
else
  puts "❌ Failed: #{course.errors.full_messages.join(', ')}"
end

# Course with no title
puts "\nTrying to create a course with no title:"
invalid_course = Course.new
if invalid_course.valid?
  invalid_course.save
  puts "✅ Course created with id: #{invalid_course.id}"
else
  puts "❌ Failed: #{invalid_course.errors.full_messages.join(', ')}"
end

# Course with too short title
puts "\nTrying to create a course with too short title:"
short_course = Course.new(title: "AB")
if short_course.valid?
  short_course.save
  puts "✅ Course created with id: #{short_course.id}"
else
  puts "❌ Failed: #{short_course.errors.full_messages.join(', ')}"
end

# Duplicate course
puts "\nTrying to create a duplicate course:"
duplicate_course = Course.new(title: "Ruby Programming")
if duplicate_course.valid?
  duplicate_course.save
  puts "✅ Course created with id: #{duplicate_course.id}"
else
  puts "❌ Failed: #{duplicate_course.errors.full_messages.join(', ')}"
end

# Test Teacher validations
puts "\n=== TEACHER VALIDATIONS ==="

# Valid teacher
puts "\nTrying to create a valid teacher:"
teacher = Teacher.new(name: "John Smith", course: course)
if teacher.valid?
  teacher.save
  puts "✅ Success: Teacher created with id: #{teacher.id}"
else
  puts "❌ Failed: #{teacher.errors.full_messages.join(', ')}"
end

# Teacher with no name
puts "\nTrying to create a teacher with no name:"
invalid_teacher = Teacher.new(course: course)
if invalid_teacher.valid?
  invalid_teacher.save
  puts "✅ Teacher created with id: #{invalid_teacher.id}"
else
  puts "❌ Failed: #{invalid_teacher.errors.full_messages.join(', ')}"
end

# Teacher with no course
puts "\nTrying to create a teacher with no course:"
no_course_teacher = Teacher.new(name: "Jane Doe")
if no_course_teacher.valid?
  no_course_teacher.save
  puts "✅ Teacher created with id: #{no_course_teacher.id}"
else
  puts "❌ Failed: #{no_course_teacher.errors.full_messages.join(', ')}"
end

# Test Topic validations
puts "\n=== TOPIC VALIDATIONS ==="

# Valid topic
puts "\nTrying to create a valid topic:"
topic = Topic.new(name: "Object-Oriented Programming", course: course)
if topic.valid?
  topic.save
  puts "✅ Success: Topic created with id: #{topic.id}"
else
  puts "❌ Failed: #{topic.errors.full_messages.join(', ')}"
end

# Duplicate topic for same course
puts "\nTrying to create a duplicate topic for the same course:"
duplicate_topic = Topic.new(name: "Object-Oriented Programming", course: course)
if duplicate_topic.valid?
  duplicate_topic.save
  puts "✅ Topic created with id: #{duplicate_topic.id}"
else
  puts "❌ Failed: #{duplicate_topic.errors.full_messages.join(', ')}"
end

# Test associations
puts "\n=== TESTING ASSOCIATIONS ==="

# Create a new course with teachers and topics
puts "\nCreating a course with teachers and topics:"
new_course = Course.create(title: "Python for Beginners")
new_course.teachers.create(name: "David Johnson")
new_course.topics.create(name: "Basic Syntax")
new_course.topics.create(name: "Data Structures")

puts "Course: #{new_course.title}"
puts "Teachers: #{new_course.teachers.map(&:name).join(', ')}"
puts "Topics: #{new_course.topics.map(&:name).join(', ')}"

# Test cascading delete
puts "\n=== TESTING DELETE CASCADE ==="
puts "Deleting course: #{new_course.title}"
puts "Before delete: #{Teacher.count} teachers, #{Topic.count} topics"
new_course.destroy
puts "After delete: #{Teacher.count} teachers, #{Topic.count} topics"

puts "\n===== TEST COMPLETE =====" 