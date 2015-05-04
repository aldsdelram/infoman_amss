class Exam < ActiveRecord::Base
  belongs_to :position

  validates :description, :presence => true, :uniqueness=>true
end
