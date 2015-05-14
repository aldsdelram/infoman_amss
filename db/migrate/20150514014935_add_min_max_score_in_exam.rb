class AddMinMaxScoreInExam < ActiveRecord::Migration
  def self.up
    add_column :exams, :total_score, :integer
    add_column :exams, :passing_score, :integer
  end

  def self.down
    remove_column :exams, :total_score
    remove_column :exams, :passing_score
  end
end
