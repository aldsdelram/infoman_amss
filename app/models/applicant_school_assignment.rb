class ApplicantSchoolAssignment < ActiveRecord::Base
	belongs_to :school
  	belongs_to :applicant
end
