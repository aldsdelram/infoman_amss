class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.integer :applicant_id
      t.integer :interviewer_id
      t.date :sched

      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
