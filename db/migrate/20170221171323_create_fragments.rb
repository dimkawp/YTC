class CreateFragments < ActiveRecord::Migration[5.0]
  def change
    create_table :fragments do |t|
      t.belongs_to :users
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
