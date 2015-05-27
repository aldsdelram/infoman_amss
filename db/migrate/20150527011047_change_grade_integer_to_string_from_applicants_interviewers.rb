class ChangeGradeIntegerToStringFromApplicantsInterviewers < ActiveRecord::Migration
  def self.up
  	change_column :applicants_interviewers, :grade, :string 
  end

  def self.down
  	change_column :applicants_interviewers, :grade, :integer
  end
end
