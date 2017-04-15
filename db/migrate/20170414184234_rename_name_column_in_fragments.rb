class RenameNameColumnInFragments < ActiveRecord::Migration[5.0]
  def change
    rename_column :fragments, :name, :title
  end
end
