class CreateInterviewers < ActiveRecord::Migration
  def self.up
    create_table :interviewers do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :interviewers
  end
end
