class DropAbbreviationFromSchool < ActiveRecord::Migration
  def self.up
  	remove_column :schools, :abbreviation
  end

  def self.down
  	add_column :schools, :abbreviation, :string
  end
end
