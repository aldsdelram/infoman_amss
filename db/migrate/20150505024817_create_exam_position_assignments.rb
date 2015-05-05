class CreateExamPositionAssignments < ActiveRecord::Migration
  def self.up
    create_table :exam_position_assignments do |t|
      t.integer :position_id
      t.integer :exam_id

      t.timestamps
    end
  end

  def self.down
    drop_table :exam_position_assignments
  end
end
