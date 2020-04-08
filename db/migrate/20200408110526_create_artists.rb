class CreateArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.integer :member_quantity
      t.references :genre, null: false, foreign_key: true
      t.string :note

      t.timestamps
    end
  end
end
