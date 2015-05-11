class School < ActiveRecord::Base
	has_many :applicant_school_assignments
	has_many :applicants

	validates :school_name, :abbreviation, :presence => true
	validates :school_name, :uniqueness => true

	def school_with_abbreviation
		"#{school_name} - #{abbreviation}"
	end
end
