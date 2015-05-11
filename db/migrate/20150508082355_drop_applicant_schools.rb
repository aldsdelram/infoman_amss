class DropApplicantSchools < ActiveRecord::Migration
  def self.up
  	drop_table :applicant_schools
  end

  def self.down
  	create_table :applicant_schools, id: false do |t|
    	t.belongs_to :applicant, index: true
      	t.belongs_to :school, index: true
  	end
  end
end
