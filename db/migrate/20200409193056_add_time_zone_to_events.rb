class AddTimeZoneToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :time_zone, :string
  end
end
