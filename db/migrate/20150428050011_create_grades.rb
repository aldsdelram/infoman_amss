class CreateGrades < ActiveRecord::Migration
  def self.up
    create_table :grades do |t|
      t.string :grade
      t.integer :exam_id

      t.timestamps
    end
  end

  def self.down
    drop_table :grades
  end
end
