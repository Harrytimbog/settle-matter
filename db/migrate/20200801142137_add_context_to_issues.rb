class AddContextToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :context, :string
  end
end
