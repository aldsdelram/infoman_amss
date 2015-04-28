class AddPositionsToInterviewer < ActiveRecord::Migration
  def self.up
    add_column :interviewers, :posistion_title, :string
    add_column :interviewers, :position_id, :integer
  end

  def self.down
    remove_column :interviewers, :position_id
    remove_column :interviewers, :posistion_title
  end
end
