class Teacher < ApplicationRecord
  belongs_to :course
  
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  
  def self.search(query)
    where("name LIKE ?", "%#{query}%")
  end
end 