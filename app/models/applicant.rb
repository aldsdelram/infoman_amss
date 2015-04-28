class Applicant < ActiveRecord::Base


validates :firstname, :lastname, :gender, :bday, :highest_school_attainment,
          :address, :email_address, :status, :position_id,
              :presence => true


end
