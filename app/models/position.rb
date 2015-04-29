class Position < ActiveRecord::Base
	has_many :applicants

  validates :title, :presence => true, :uniqueness => true

end
