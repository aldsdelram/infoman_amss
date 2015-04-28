class ChangePosistionTitleInInterviewer < ActiveRecord::Migration
  def change
    rename_column :interviewes, :posistion_title, :position_title
  end
end
