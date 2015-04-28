class CreateApplicants < ActiveRecord::Migration
  def self.up
    create_table :applicants do |t|
      t.string :lastname
      t.string :firstname
      t.string :middlename
      t.date :bday
      t.string :gender
      t.string :highest_school_attainment
      t.text :address
      t.string :email_address
      t.string :contact
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :applicants
  end
end
