class AddDepartmentIdToInterviewers < ActiveRecord::Migration
  def self.up
    add_column :interviewers, :department_id, :integer
  end

  def self.down
    remove_column :interviewers, :department_id
  end
end
