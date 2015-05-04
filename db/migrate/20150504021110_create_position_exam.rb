class CreatePositionExam < ActiveRecord::Migration
  def self.up
    create_table :positions_exams, id: false do |t|
      t.belongs_to :position, index: true
      t.belongs_to :exam, index: true
    end
  end

  def self.down
  	 drop_table :positions_exams
  end
end