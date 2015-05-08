class School < ActiveRecord::Base
	has_many :applicants

	def school_with_abbreviation
		"#{school_name} - #{abbreviation}"
	end
end
