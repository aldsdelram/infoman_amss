class Exam < ActiveRecord::Base
  has_many :exam_position_assignment
  has_many :positions, :through => :exam_position_assignment

  validates :title, :presence => true, :uniqueness=>true
end
