class DropSchoolIdFromApplicants < ActiveRecord::Migration
  def self.up
  	remove_column :applicants, :school_id
  end

  def self.down
  	add_column :applicants, :school_id, :integer
  end
end
