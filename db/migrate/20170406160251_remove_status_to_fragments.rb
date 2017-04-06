class RemoveStatusToFragments < ActiveRecord::Migration[5.0]
  def change
    remove_column :fragments, :string, :string
  end
end
