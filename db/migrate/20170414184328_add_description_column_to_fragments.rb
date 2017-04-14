class AddDescriptionColumnToFragments < ActiveRecord::Migration[5.0]
  def change
    add_column :fragments, :description, :text, after: :title
  end
end
