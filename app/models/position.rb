class Position < ActiveRecord::Base
	has_many :applicants
  has_many :exam_position_assignment
  has_many :exams, :through => :exam_position_assignment

  validates :title, :presence => true, :uniqueness => true
end
