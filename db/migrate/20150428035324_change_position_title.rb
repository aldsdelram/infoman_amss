class ChangePositionTitle < ActiveRecord::Migration
  def self.up
    rename_column :interviewers, :posistion_title, :position_title
  end

  def self.down

  end
end
