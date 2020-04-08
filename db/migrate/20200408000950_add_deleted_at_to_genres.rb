class AddDeletedAtToGenres < ActiveRecord::Migration[6.0]
  def change
    add_column :genres, :deleted_at, :datetime
    add_index :genres, :deleted_at
  end
end
