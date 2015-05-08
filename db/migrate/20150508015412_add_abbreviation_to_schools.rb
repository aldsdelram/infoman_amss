class AddAbbreviationToSchools < ActiveRecord::Migration
  def self.up
    add_column :schools, :abbreviation, :string
  end

  def self.down
    remove_column :schools, :abbreviation
  end
end
