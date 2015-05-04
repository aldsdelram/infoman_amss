class Position < ActiveRecord::Base
	has_many :applicants
  has_and_belongs_to_many :exams

  validates :title, :presence => true, :uniqueness => true

end
