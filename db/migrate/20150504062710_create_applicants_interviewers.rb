class CreateApplicantsInterviewers < ActiveRecord::Migration
  def self.up
  	create_table :applicants_interviewers, id: false do |t|
      t.belongs_to :applicant, index: true
      t.belongs_to :interviewer, index: true
    end
  end

  def self.down
  	 drop_table :applicants_interviewers
  end
end