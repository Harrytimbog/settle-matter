class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.text :question
      t.integer :category
      t.string :tag
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
