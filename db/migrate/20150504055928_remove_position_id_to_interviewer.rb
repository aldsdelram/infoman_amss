class RemovePositionIdToInterviewer < ActiveRecord::Migration
  def self.up
    remove_column :interviewers, :position_id
  end

  def self.down
    add_column :interviewers, :position_id, :integer
  end
end
