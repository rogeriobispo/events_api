class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.integer :type
      t.date :occurred_on
      t.string :location
      t.date :line_up_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

