class CreateApplicantSchoolAssignments < ActiveRecord::Migration
  def self.up
    create_table :applicant_school_assignments do |t|
      t.integer :applicant_id
      t.integer :school_id

      t.timestamps
    end
  end

  def self.down
    drop_table :applicant_school_assignments
  end
end
