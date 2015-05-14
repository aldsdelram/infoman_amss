class Grade < ActiveRecord::Base
  belongs_to :exam
  belongs_to :applicant
end
