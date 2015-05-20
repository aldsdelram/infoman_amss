class RenameFailedButHiredInApplicants < ActiveRecord::Migration
  def self.up
  	rename_column :applicants, :failed_but_hired, :consider
  end

  def self.down
  	
  end
end
