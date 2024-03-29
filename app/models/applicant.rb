class Applicant < ActiveRecord::Base

belongs_to :position

has_many :schedules

has_one :applicant_school_assignment

has_one :school, :through => :applicant_school_assignment

has_and_belongs_to_many :interviewers

has_many :grades

has_many :exams, :through => :grades

# has_many :exams, :through => :grades

attr_accessor :image

SEARCH_CATEGORIES = [["FIRSTNAME",0], ["LASTNAME",1], ["SCHOOL",2]]

validates :firstname, :lastname, :gender, :bday, :highest_school_attainment,
          :address, :email_address, :status, :position_id,
          	:presence => true

validates :school, :presence => true

end
