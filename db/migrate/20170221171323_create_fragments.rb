class CreateFragments < ActiveRecord::Migration[5.0]
  def change
    create_table :fragments do |t|
      t.belongs_to :user
      t.string :video_id
      t.string :title
      t.text :description
      t.string :url
      t.string :cloud_url
      t.integer :start
      t.integer :end
      t.string :status
      t.timestamps
    end
  end
end
