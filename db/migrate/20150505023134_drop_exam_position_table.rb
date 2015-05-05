class DropExamPositionTable < ActiveRecord::Migration
  def self.up
    drop_table :exams_positions
  end

  def self.down
    create_table :exams_positions, id: false do |t|
      t.belongs_to :position, index: true
      t.belongs_to :exam, index: true
    end
  end
end
