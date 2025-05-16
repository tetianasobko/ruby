class Course < ApplicationRecord
  has_many :teachers, dependent: :destroy
  has_many :topics, dependent: :destroy
  
  validates :title, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
  
  def self.search(query)
    where("title LIKE ?", "%#{query}%")
  end
end
