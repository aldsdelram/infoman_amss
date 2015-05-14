class School < ActiveRecord::Base
	has_many :applicant_school_assignments
	has_many :applicants, :through=> :applicant_school_assignments

	validates :school_name, :acronym, :presence => true
	validates :school_name, :uniqueness => true

	def school_with_acronym
		"#{school_name} - #{acronym}"
	end
end
