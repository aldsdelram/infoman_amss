class Exam < ActiveRecord::Base
  has_and_belongs_to_many :positions

  validates :title, :presence => true, :uniqueness=>true
end
