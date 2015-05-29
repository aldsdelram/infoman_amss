class CreateAdminLogs < ActiveRecord::Migration
  def self.up
    create_table :admin_logs do |t|
      t.integer :admin_id
      t.string :log

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_logs
  end
end
