class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :v
      t.string :url
      t.string :title
      t.integer :duration
      t.text :description
      t.json :cloudinary
      t.string :status
      t.timestamps
    end

    add_index :videos, :v, unique: true
  end
end
