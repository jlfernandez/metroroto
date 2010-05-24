class AddLatLongZoomToLines < ActiveRecord::Migration
  def self.up
    add_column :lines, :center_lat, :float
    add_column :lines, :center_long, :float
    add_column :lines, :zoom, :integer
  end

  def self.down
    remove_column :lines, :center_lat
    remove_column :lines, :center_long
    remove_column :lines, :zoom
  end
end
