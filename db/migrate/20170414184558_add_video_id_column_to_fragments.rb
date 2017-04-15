class AddVideoIdColumnToFragments < ActiveRecord::Migration[5.0]
  def change
    add_column :fragments, :video_id, :string, after: :user_id
  end
end
