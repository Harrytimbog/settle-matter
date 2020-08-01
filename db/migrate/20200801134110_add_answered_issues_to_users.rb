class AddAnsweredIssuesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :answered_issues, :integer
  end
end
