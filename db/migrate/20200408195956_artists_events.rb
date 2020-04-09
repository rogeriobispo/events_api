class ArtistsEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :artists_events do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
    end
  end
end
