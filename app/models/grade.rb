class Grade < ActiveRecord::Base
  belongs_to :exam
  belongs_to :applicant

  validates :score, :numericality => { only_integer: true,
                             greater_than: 0, :allow_blank=> true}
  validates_uniqueness_of :exam_id, :scope=>:applicant_id

  validate :score_is_not_greater_than

  def score_is_not_greater_than
    exam = Exam.find(exam_id)
    if !score.nil?
      if score.to_i > exam.total_score
        errors.add(:score, "can't be greater than the total score")
      end
    end
  end
end
