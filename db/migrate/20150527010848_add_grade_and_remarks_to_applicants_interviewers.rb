class AddGradeAndRemarksToApplicantsInterviewers < ActiveRecord::Migration
  def self.up
    add_column :applicants_interviewers, :grade, :integer
    add_column :applicants_interviewers, :remarks, :string
  end

  def self.down
    remove_column :applicants_interviewers, :remarks
    remove_column :applicants_interviewers, :grade
  end
end
