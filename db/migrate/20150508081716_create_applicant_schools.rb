class CreateApplicantSchools < ActiveRecord::Migration
  def self.up
  	  create_table :applicant_schools, id: false do |t|
    	t.belongs_to :applicant, index: true
      	t.belongs_to :school, index: true
  	end
  end

  def self.down
  	drop_table :applicant_schools
  end
end
