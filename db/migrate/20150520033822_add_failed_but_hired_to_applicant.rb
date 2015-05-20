class AddFailedButHiredToApplicant < ActiveRecord::Migration
  def self.up
    add_column :applicants, :failed_but_hired, :integer
  end

  def self.down
    remove_column :applicants, :failed_but_hired
  end
end
