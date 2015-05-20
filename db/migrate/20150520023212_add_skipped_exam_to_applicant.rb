class AddSkippedExamToApplicant < ActiveRecord::Migration
  def self.up
    add_column :applicants, :skipped_exam, :integer
  end

  def self.down
    remove_column :applicants, :skipped_exam
  end
end
