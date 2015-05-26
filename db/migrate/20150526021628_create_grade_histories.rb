class CreateGradeHistories < ActiveRecord::Migration
  def self.up
    create_table :grade_histories do |t|
    	t.integer :applicant_re_applications_id
    	t.integer :exam_id

      t.timestamps
    end
  end

  def self.down
    drop_table :grade_histories
  end
end
