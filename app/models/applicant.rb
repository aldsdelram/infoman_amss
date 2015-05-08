class Applicant < ActiveRecord::Base
belongs_to :position

has_one :schedule

has_one :school

has_and_belongs_to_many :interviewers

attr_accessor :image

SEARCH_CATEGORIES = ["FIRSTNAME", "LASTNAME", "SCHOOL"]

validates :firstname, :lastname, :gender, :bday, :highest_school_attainment,
          :address, :email_address, :status, :position_id, 
          	:presence => true
end
