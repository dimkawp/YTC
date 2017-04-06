class AddStatusToFragments < ActiveRecord::Migration[5.0]
  def change
    add_column :fragments, :status, :string
  end
end
