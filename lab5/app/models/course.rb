class Course < ApplicationRecord
  has_many :teachers, dependent: :destroy
  has_many :topics, dependent: :destroy
  
  validates :title, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
  
  # Accept nested attributes for teachers
  accepts_nested_attributes_for :teachers, allow_destroy: true, reject_if: :all_blank
  
  # Method to handle teacher IDs assignment
  def teacher_ids=(ids)
    ids = ids.reject(&:blank?).map(&:to_i)
    
    # Handle existing teachers that should be assigned to this course
    Teacher.where(id: ids).update_all(course_id: self.id) if self.persisted?
  end
  
  def self.search(query)
    where("title LIKE ?", "%#{query}%")
  end
end
