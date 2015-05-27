class RemoveGradeAndRemarksToApplicantsInterviewers < ActiveRecord::Migration
  def self.up
    remove_column :applicants_interviewers, :grade
    remove_column :applicants_interviewers, :remarks
  end

  def self.down
    add_column :applicants_interviewers, :remarks, :string
    add_column :applicants_interviewers, :grade, :string
  end
end
