class AddImageNameToApplicant < ActiveRecord::Migration
  def self.up
    add_column :applicants, :image_name, :string
  end

  def self.down
    remove_column :applicants, :image_name
  end
end
