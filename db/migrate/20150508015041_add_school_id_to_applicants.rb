class AddSchoolIdToApplicants < ActiveRecord::Migration
  def self.up
    add_column :applicants, :school_id, :integer
  end

  def self.down
    remove_column :applicants, :school_id
  end
end
