class AddGradeAndRemarksToSchedule < ActiveRecord::Migration
  def self.up
    add_column :schedules, :grade, :string
    add_column :schedules, :remarks, :string
  end

  def self.down
    remove_column :schedules, :remarks
    remove_column :schedules, :grade
  end
end
