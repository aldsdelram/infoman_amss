class AddScoreToGradeHistories < ActiveRecord::Migration
  def self.up
    add_column :grade_histories, :score, :integer
  end

  def self.down
    remove_column :grade_histories, :score
  end
end
