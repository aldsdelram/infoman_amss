class AddImageNameToAdmin < ActiveRecord::Migration
  def self.up
    add_column :admins, :image_name, :string
  end

  def self.down
    remove_column :admins, :image_name
  end
end
