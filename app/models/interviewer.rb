class Interviewer < ActiveRecord::Base
	attr_accessor :image
	has_and_belongs_to_many :applicants
	belongs_to :department
end
