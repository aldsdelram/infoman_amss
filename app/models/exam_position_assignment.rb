class ExamPositionAssignment < ActiveRecord::Base
  belongs_to :exam
  belongs_to :position

  validates_uniqueness_of :exam_id, :scope => :position_id
end
