class ChangePosistionTitle < ActiveRecord::Migration
  def self.up
    rename_column :interviewes, :posistion_title, :position_title
  end

  def self.down

  end
end
