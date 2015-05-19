class ApplicantSchoolAssignment < ActiveRecord::Base
  belongs_to :school
  belongs_to :applicant

  validates_uniqueness_of :applicant_id, :scope => :school_id
end
