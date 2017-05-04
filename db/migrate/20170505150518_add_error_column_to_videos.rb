class AddErrorColumnToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :error, :string
  end
end
