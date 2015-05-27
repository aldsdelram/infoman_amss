class RemoveApplicantsInterviewersIdToSchedule < ActiveRecord::Migration
  def self.up
    remove_column :schedules, :applicants_interviewers_id
  end

  def self.down
    add_column :schedules, :applicants_interviewers_id, :integer
  end
end
