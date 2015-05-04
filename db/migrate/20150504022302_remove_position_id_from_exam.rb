class RemovePositionIdFromExam < ActiveRecord::Migration
  def self.up
    remove_column :exams, :position_id
  end

  def self.down
    add_column :exams, :position_id, :integer
  end
end
