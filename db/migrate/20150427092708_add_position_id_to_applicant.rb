class AddPositionIdToApplicant < ActiveRecord::Migration
  def self.up
    add_column :applicants, :position_id, :integer
  end

  def self.down
    remove_column :applicants, :position_id
  end
end
