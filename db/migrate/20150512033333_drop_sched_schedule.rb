class DropSchedSchedule < ActiveRecord::Migration
  def self.up
  	remove_column :schedules, :sched
  end

  def self.down
  	add_column :schedules, :sched, :datetime
  end
end
