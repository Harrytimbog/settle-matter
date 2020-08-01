class AddExpiredAtToIssue < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :expired_at, :datetime
  end
end
