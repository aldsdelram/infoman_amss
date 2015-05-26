class CreateApplicantReApplications < ActiveRecord::Migration
  def self.up
    create_table :applicant_re_applications do |t|
    	t.integer :applicant_id
    	t.integer :applied_for
    	
      t.timestamps
    end
  end

  def self.down
    drop_table :applicant_re_applications
  end
end
