class AddIndexToEventsType < ActiveRecord::Migration[6.0]
  def change
    add_index :events, :kind
  end
end
