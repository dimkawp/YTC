class AddParamsToFragments < ActiveRecord::Migration[5.0]
  def change
    add_column :fragments, :cloud_url, :string
    add_column :fragments, :start, :integer
    add_column :fragments, :end, :integer
  end
end
