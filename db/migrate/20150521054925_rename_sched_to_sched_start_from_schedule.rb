class RenameSchedToSchedStartFromSchedule < ActiveRecord::Migration
  def self.up
  	rename_column :schedules, :sched, :sched_start
  end

  def self.down
  end
end
