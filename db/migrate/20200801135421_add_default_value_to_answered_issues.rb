class AddDefaultValueToAnsweredIssues < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :answered_issues, 0
  end
end
