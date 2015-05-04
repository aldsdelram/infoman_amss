class RenamePositionExamToExamPosition < ActiveRecord::Migration
  def self.up
    rename_table :positions_exams, :exams_positions
  end

  def self.down
    rename_table :exams_positions, :positions_exams
  end
end
