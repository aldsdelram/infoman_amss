class AddAcronymToSchool < ActiveRecord::Migration
  def self.up
    add_column :schools, :acronym, :string
  end

  def self.down
    remove_column :schools, :acronym
  end
end
