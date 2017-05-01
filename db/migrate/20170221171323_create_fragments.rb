class CreateFragments < ActiveRecord::Migration[5.0]
  def change
    create_table :fragments do |t|
      t.belongs_to :user
      t.belongs_to :video
      t.string :url
      t.string :title
      t.integer :start_from
      t.integer :end_from
      t.text :description
      t.string :status
      t.timestamps
    end
  end
end
