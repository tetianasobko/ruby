class Teacher < ApplicationRecord
  has_and_belongs_to_many :courses
  
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  
  def self.search(query)
    where("name LIKE ?", "%#{query}%")
  end
end 