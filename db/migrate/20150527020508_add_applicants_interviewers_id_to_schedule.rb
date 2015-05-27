class AddApplicantsInterviewersIdToSchedule < ActiveRecord::Migration
  def self.up
    add_column :schedules, :applicants_interviewers_id, :integer
  end

  def self.down
    remove_column :schedules, :applicants_interviewers_id
  end
end
