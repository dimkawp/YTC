class AddTokenColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :token, :string, after: :email
  end
end
