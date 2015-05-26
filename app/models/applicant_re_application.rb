class ApplicantReApplication < ActiveRecord::Base
	belongs_to :applicant
	belongs_to :position, :foreign_key => :applied_for
	
	has_many :grade_histories
end
