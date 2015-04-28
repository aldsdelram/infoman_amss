class Applicant < ActiveRecord::Base

SEARCH_CATEGORIES = ["FIRSTNAME", "LASTNAME", "SCHOOL", "DATE APPLIED"]

validates :firstname, :lastname, :gender, :bday, :highest_school_attainment,
          :address, :email_address, :status, :position_id,
              :presence => true
end
