class ChangeGrades < ActiveRecord::Migration
  def self.up
    add_column :grades, :applicant_id, :integer
    add_column :grades, :remarks, :text
    rename_column :grades, :grade, :score
  end

  def self.down
    remove_column :grades, :applicant_id
    remove_column :grades, :remarks
    rename_column :grades, :score, :grade
  end
end
