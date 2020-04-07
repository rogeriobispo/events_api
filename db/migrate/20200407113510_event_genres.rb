class EventGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :event_genres do |t|
      t.references :genre, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
    end
  end
end
