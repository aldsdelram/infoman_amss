class AddSchedToSchedule < ActiveRecord::Migration
  def self.up
    add_column :schedules, :sched, :datetime
  end

  def self.down
    remove_column :schedules, :sched
  end
end
