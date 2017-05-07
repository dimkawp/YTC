class AddErrorColumnToFragments < ActiveRecord::Migration[5.0]
  def change
    add_column :fragments, :error, :string
  end
end
