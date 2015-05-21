class AddSchedEndToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :sched_end, :datetime
  end

  def self.down
    remove_column :schedules, :sched_end
  end
end
