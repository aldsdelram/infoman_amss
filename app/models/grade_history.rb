class GradeHistory < ActiveRecord::Base

	belongs_to :applicant_re_application, :foreign_key => :applicant_re_applications_id

end