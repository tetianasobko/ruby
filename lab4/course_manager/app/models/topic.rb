class Topic < ApplicationRecord
  belongs_to :course
  
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :name, uniqueness: { scope: :course_id, message: "already exists for this course" }
  
  def self.search(query)
    where("name LIKE ?", "%#{query}%")
  end
end 