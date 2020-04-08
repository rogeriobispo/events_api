class AddDeletedAtToArtists < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :deleted_at, :datetime
    add_index :artists, :deleted_at
  end
end
