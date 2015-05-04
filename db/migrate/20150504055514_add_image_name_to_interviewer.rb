class AddImageNameToInterviewer < ActiveRecord::Migration
  def self.up
    add_column :interviewers, :image_name, :string
  end

  def self.down
    remove_column :interviewers, :image_name
  end
end
