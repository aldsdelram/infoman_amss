class Exam < ActiveRecord::Base
  has_many :exam_position_assignment
  has_many :positions, :through => :exam_position_assignment
  has_many :grades

  validates :title, :presence => true, :uniqueness=>true
  validates :total_score, :passing_score, :presence=> true
  validates :total_score, :numericality => { only_integer: true,
                           greater_than: 0}
  validates :passing_score, :numericality => { only_integer: true,
                           greater_than: 0}
  validates :passing_score, :numericality => {
                          less_than_or_equal_to: :total_score,
                          :message=> "must be less than or equal" +
                          " to the Total Score"}

end
