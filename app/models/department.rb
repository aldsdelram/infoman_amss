class Department < ActiveRecord::Base
	has_many :interviewers

	validates :department_name, :presence => true
	validates :department_name, :uniqueness => true
end
