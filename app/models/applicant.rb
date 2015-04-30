class Applicant < ActiveRecord::Base
belongs_to :position
attr_accessor :image


SEARCH_CATEGORIES = ["FIRSTNAME", "LASTNAME", "SCHOOL"]

validates :firstname, :lastname, :gender, :bday, :highest_school_attainment,
          :address, :email_address, :status, :position_id, 
          	:presence => true
end
