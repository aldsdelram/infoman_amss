class Department < ActiveRecord::Base
	has_many :interviewers
end
