class Course < ApplicationRecord
  has_and_belongs_to_many :teachers
  has_many :topics, dependent: :destroy
  
  validates :title, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
  
  accepts_nested_attributes_for :topics, allow_destroy: true, reject_if: :all_blank
  
  def self.search(query)
    where("title LIKE ?", "%#{query}%")
  end
end
