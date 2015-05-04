class Position < ActiveRecord::Base
	has_many :applicants
  has_many :exams

  validates :title, :presence => true, :uniqueness => true

end
